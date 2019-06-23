//
//  DataController.swift
//  MarvelSwift
//
//  Created by Carsten Könemann on 22.06.2019.
//  Copyright © 2019 cargath. All rights reserved.
//

import MarvelKit

class DataController {

    let marvelKitController: MarvelKitController

    let coreDataController: CoreDataController

    init(marvelKitController: MarvelKitController, coreDataController: CoreDataController) {
        self.marvelKitController = marvelKitController
        self.coreDataController = coreDataController
        self.marvelKitController.delegate = self
    }

    func update() {
        marvelKitController.update()
    }

}

extension DataController: MarvelKitControllerDelegate {

    func marvelKitController(_ marvelKitController: MarvelKitController, didReceiveAttribution attribution: String) {
        // TODO: Implement
        print(attribution)
    }

    func marvelKitController(_ marvelKitController: MarvelKitController, didReceiveComics comics: [MarvelKit.Comic]) {
        coreDataController.persistentContainer.performBackgroundTask { backgroundContext in
            ComicEntity.updateOrInsert(with: comics, into: backgroundContext)
            backgroundContext.saveChanges()
        }
    }

    func marvelKitController(_ marvelKitController: MarvelKitController, didReceiveSeries series: [MarvelKit.Series]) {
        coreDataController.persistentContainer.performBackgroundTask { backgroundContext in
            SeriesEntity.updateOrInsert(with: series, into: backgroundContext)
            backgroundContext.saveChanges()
        }
    }

    func marvelKitController(_ marvelKitController: MarvelKitController, didReceiveError error: Swift.Error) {
        // TODO: Implement
        print(error.localizedDescription)
    }

}

extension DataController {

    func solicitationsViewModel() -> FetchedObjectsViewModel<ComicEntity> {
        return FetchedObjectsViewModel(fetchedResultsController: coreDataController.fetchedSolicitationsController())
    }

    func pullListViewModel() -> FetchedObjectsViewModel<ComicEntity> {
        return FetchedObjectsViewModel(fetchedResultsController: coreDataController.fetchedPullListController())
    }

}

extension DataController {

    static let shared = DataController(
        marvelKitController: MarvelKitController(),
        coreDataController: CoreDataController()
    )

}
