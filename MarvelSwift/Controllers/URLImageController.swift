//
//  URLImageController.swift
//  MarvelSwift
//
//  Created by Carsten Könemann on 27.06.2019.
//  Copyright © 2019 cargath. All rights reserved.
//

import UIKit

class URLImageController {

    static let shared: URLImageController = .init()

    private let cache: Cache<NSURL, UIImage> = .init()

    private let broadcast: Broadcast<URL, URLImage> = .init()

    func getImage(with url: URL, completionHandler: @escaping (URLImage) -> Void) {

        if let image = cache[url] {
            completionHandler(.remote(image))
            return
        }

        if !broadcast.add(subscriber: completionHandler, for: url) {
            return
        }

        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            if let data = data, let image = UIImage(data: data) {
                self?.cache[url] = image
                // Call the given completion handler if the broadcast fails.
                if !(self?.broadcast.send(value: .remote(image), for: url) ?? false) {
                    completionHandler(.remote(image))
                }
            } else {
                // Call the given completion handler if the broadcast fails.
                if !(self?.broadcast.send(value: .unavailable, for: url) ?? false) {
                    completionHandler(.unavailable)
                }
            }
        }

        task.resume()
    }

}
