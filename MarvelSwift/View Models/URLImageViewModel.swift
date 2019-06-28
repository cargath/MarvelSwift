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

    var image: URLImage = .placeholder {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.didChange.send()
            }
        }
    }

    private(set) var downloading: Bool = false

    // MARK: BindableObject
    var didChange = PassthroughSubject<Void, Never>()

    init(url: URL) {
        self.url = url
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
