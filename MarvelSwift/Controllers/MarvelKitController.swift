//
//  MarvelKitController.swift
//  MarvelSwift
//
//  Created by Carsten Könemann on 22.06.2019.
//  Copyright © 2019 cargath. All rights reserved.
//

import Combine
import Foundation
import MarvelKit

// MARK: - MarvelKitClient helpers

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

// MARK: - MarvelKitControllerDelegate

protocol MarvelKitControllerDelegate: class {

    func marvelKitController(_ marvelKitController: MarvelKitController, didReceiveAttribution attribution: String)

    func marvelKitController(_ marvelKitController: MarvelKitController, didReceiveComics comics: [MarvelKit.Comic])

    func marvelKitController(_ marvelKitController: MarvelKitController, didReceiveSeries series: [MarvelKit.Series])

    func marvelKitController(_ marvelKitController: MarvelKitController, didReceiveError error: Swift.Error)

}

// MARK: - MarvelKitController

class MarvelKitController {

    let marvelKitClient: MarvelKitClient

    let urlSession: URLSession

    weak var delegate: MarvelKitControllerDelegate?

    init(marvelKitClient: MarvelKitClient = .shared, urlSession: URLSession = .shared) {
        self.marvelKitClient = marvelKitClient
        self.urlSession = urlSession
    }

}

// MARK: - MarvelKitController + MarvelKitClient

extension MarvelKitController {

    func update() {
        let _ = urlSession
            .resourceTaskPublisher(with: marvelKitClient.solicitsRequest)
            .sink(receiveCompletion: receiver(completion:), receiveValue: receiver(dataWrapper:))
    }

    func receiver(dataWrapper: DataWrapper<DataContainer<Comic>>) {

        if let attributionText = dataWrapper.attributionText {
            delegate?.marvelKitController(self, didReceiveAttribution: attributionText)
        }

        if let comics = dataWrapper.data?.results {
            delegate?.marvelKitController(self, didReceiveComics: comics)
            // We can't fetch multiple series IDs at once.
            // We can fetch series which contain one of multiple comic IDs.
            // -> Compute the ID of the first comic of each series.
            let seriesIDs = Set(comics.compactMap({ $0.series?.id }))
            let comicIDs = seriesIDs.compactMap({ seriesID in comics.filter({ $0.series?.id == seriesID }).first?.id })
            // We can't filter by more than 10 comic IDs at once.
            // -> Split comic IDs into chunks of 10 elements each.
            let chunks = comicIDs.compactMap(Int.init).chunks(10)
            // Fetch series information for each chunk of comic IDs.
            for chunk in chunks {
                let _ = urlSession
                    .resourceTaskPublisher(with: marvelKitClient.seriesRequest(comics: chunk))
                    .sink(receiveCompletion: receiver(completion:), receiveValue: receiver(dataWrapper:))
            }
        }
    }

    func receiver(dataWrapper: DataWrapper<DataContainer<Series>>) {
        if let series = dataWrapper.data?.results {
            delegate?.marvelKitController(self, didReceiveSeries: series)
        }
    }

    func receiver(completion: Subscribers.Completion<Swift.Error>) {
        switch completion {
            case .failure(let error):
                delegate?.marvelKitController(self, didReceiveError: error)
            case .finished:
                delegate?.marvelKitController(self, didReceiveError: MarvelKit.Error(message: "No data received.", code: "NoData"))
        }
    }

}
