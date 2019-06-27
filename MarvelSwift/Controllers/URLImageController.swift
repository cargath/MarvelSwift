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

    private var cache: NSCache<NSURL, UIImage> = .init()

    private var completionHandlers: [URL: [(URLImage) -> Void]] = [:]

    func getImage(with url: URL, completionHandler: @escaping (URLImage) -> Void) {

        if let image = cache.object(forKey: url as NSURL) {
            completionHandler(.remote(image))
            return
        }

        if completionHandlers.keys.contains(url) {
            completionHandlers[url]?.append(completionHandler)
            return
        }

        completionHandlers[url] = [completionHandler]

        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            if let data = data, let image = UIImage(data: data) {
                self?.cache.setObject(image, forKey: url as NSURL)
                self?.didReceive(.remote(image), for: url, with: completionHandler)
            } else {
                self?.didReceive(.unavailable, for: url, with: completionHandler)
            }
        }

        task.resume()
    }

    private func didReceive(_ image: URLImage, for url: URL, with completionHandler: @escaping (URLImage) -> Void) {

        guard let completionHandlers = self.completionHandlers[url] else {
            completionHandler(image)
            return
        }

        self.completionHandlers.removeValue(forKey: url)

        for completionHandler in completionHandlers {
            completionHandler(image)
        }
    }

}
