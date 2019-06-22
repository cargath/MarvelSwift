//
//  DataController.swift
//  MarvelSwift
//
//  Created by Carsten Könemann on 22.06.2019.
//  Copyright © 2019 cargath. All rights reserved.
//

class DataController {

    let marvelKitController: MarvelKitController

    let coreDataController: CoreDataController

    init(marvelKitController: MarvelKitController, coreDataController: CoreDataController) {
        self.marvelKitController = marvelKitController
        self.coreDataController = coreDataController
    }

    func update() {
        coreDataController.persistentContainer.performBackgroundTask { backgroundContext in

            let comicZero = ComicEntity.init(context: backgroundContext)
            comicZero.uniqueIdentifier = 0
            comicZero.title = "Captain Marvel"

            let comicOne = ComicEntity.init(context: backgroundContext)
            comicOne.uniqueIdentifier = 1
            comicOne.title = "Hawkeye"

            let comicTwo = ComicEntity.init(context: backgroundContext)
            comicTwo.uniqueIdentifier = 2
            comicTwo.title = "X-Men"

            // TODO: Improve error handling
            do {
                try backgroundContext.save()
            } catch {
                print("FOOBAR: \(error.localizedDescription)")
            }
        }
    }

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
