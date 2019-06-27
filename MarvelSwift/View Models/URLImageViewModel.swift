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

    var image: URLImage = .placeholder {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.didChange.send()
            }
        }
    }

    // MARK: BindableObject
    var didChange = PassthroughSubject<Void, Never>()

    init(url: URL) {
        URLImageController.shared.getImage(with: url, completionHandler: didReceive(image:))
    }

    func didReceive(image: URLImage) {
        self.image = image
    }

}
