//
//  MarvelKitController.swift
//  MarvelSwift
//
//  Created by Carsten Könemann on 22.06.2019.
//  Copyright © 2019 cargath. All rights reserved.
//

import Foundation
import MarvelKit

extension MarvelKitClient {

    var solicitsRequest: MarvelKit.Request<MarvelKit.Comic> {
        return request(MarvelKit.Comic.self).withParameters([
            .format(.Comic),
            .formatType(.Comic),
            .noVariants(true),
            .dateRange(Date(), Date(timeIntervalSinceNow: 60 * 60 * 24 * 356)),
            .orderBy([.OnSaleDateAscending]),
            .limit(100)
        ])
    }

    func seriesRequest(comics: [Int]) -> MarvelKit.Request<MarvelKit.Series> {
        return request(MarvelKit.Series.self).withParameters([
            .comics(comics)
        ])
    }

}

extension MarvelKitClient {

    static let shared = MarvelKitClient(
        privateKey: LocalConfig.privateKey,
        publicKey: LocalConfig.publicKey
    )

}

class MarvelKitController {

    let marvelKitClient: MarvelKitClient

    let urlSession: URLSession

    init(marvelKitClient: MarvelKitClient = .shared, urlSession: URLSession = .shared) {
        self.marvelKitClient = marvelKitClient
        self.urlSession = urlSession
    }

    func update() {
        // TODO: Fetch data
    }

}
