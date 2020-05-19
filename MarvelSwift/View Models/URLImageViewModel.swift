//
//  URLImageViewModel.swift
//  MarvelSwift
//
//  Created by Carsten Könemann on 27.06.2019.
//  Copyright © 2019 cargath. All rights reserved.
//

import Combine
import SwiftUI

class URLImageViewModel: BindableObject {

    let url: URL

    private(set) var image: URLImage {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.willChange.send()
            }
        }
    }

    private(set) var downloading: Bool = false

    // MARK: BindableObject
    var willChange = PassthroughSubject<Void, Never>()

    init(url: URL) {
        self.url = url
        // URLImageView only triggers `load()` when the placeholder is being show.
        // -> If we are able to initialize `image` from the cache, we don't trigger an immediate refresh of the view.
        self.image = URLImageController.shared.getImageSync(with: url)
    }

    func load() {
        if !downloading {
            downloading = true
            URLImageController.shared.getImage(with: url, completionHandler: didReceive(image:))
        }
    }

    func didReceive(image: URLImage) {
        self.image = image
        self.downloading = false
    }

}
