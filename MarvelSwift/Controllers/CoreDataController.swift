//
//  CoreDataController.swift
//  MarvelSwift
//
//  Created by Carsten Könemann on 22.06.2019.
//  Copyright © 2019 cargath. All rights reserved.
//

import CoreData

class CoreDataController {

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = { // NSPersistentCloudKitContainer = {
        /*
         The persistent container for the application.
         This implementation creates and returns a container, having loaded the store for the application to it.
         This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "MarvelSwift") // NSPersistentCloudKitContainer(name: "MarvelSwift")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate.
                // You should not use this function in a shipping application, although it may be useful during development.

                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                // TODO: Test whether this works + retry setting up a clean stack
                if let url = storeDescription.url {
                    do {
                        try container.persistentStoreCoordinator.destroyPersistentStore(at: url, ofType: storeDescription.type, options: nil)
                    } catch {
                        let nserror = error as NSError
                        fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                    }
                } else {
                    fatalError("Unresolved error \(error), \(error.userInfo)")
                }
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        return container
    }()

    // MARK: - FetchedResultsController factory methods

    func fetchedSolicitationsController() -> NSFetchedResultsController<ComicEntity> {
        return NSFetchedResultsController(
            fetchRequest: ComicEntity.fetchRequest().unsorted(),
            managedObjectContext: persistentContainer.viewContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
    }

    func fetchedPullListController() -> NSFetchedResultsController<ComicEntity> {
        return NSFetchedResultsController(
            fetchRequest: ComicEntity.fetchRequest().unsorted(),
            managedObjectContext: persistentContainer.viewContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
    }

    func fetchedSubscriptionsController() -> NSFetchedResultsController<SeriesEntity> {
        return NSFetchedResultsController(
            fetchRequest: SeriesEntity.fetchRequest().unsorted(),
            managedObjectContext: persistentContainer.viewContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
    }

}
