//
//  NSManagedObjectContext+MarvelSwift.swift
//  MarvelSwift
//
//  Created by Carsten Könemann on 23.06.2019.
//  Copyright © 2019 cargath. All rights reserved.
//

import CoreData

// MARK: - ManagedObjectProtocol

protocol ManagedObjectProtocol: NSFetchRequestResult {

    var managedObjectContext: NSManagedObjectContext? { get }

    static func entity() -> NSEntityDescription

}

extension NSManagedObject: ManagedObjectProtocol {
    //
}

// MARK: - NSManagedObjectContext+Result

extension NSManagedObjectContext {

    func saveChanges() {

        if !hasChanges {
            return
        }

        do {
            try save()
        } catch {
            print(error.localizedDescription)
            return
        }
    }

    func fetch<T: ManagedObjectProtocol>(key: String, value: String) -> [T] {
        do {
            return try fetch(
                NSFetchRequest<T>(entityName: T.entity().name!).with(NSPredicate(format: "\(key) = \(value)"))
            )
        } catch {
            print(error.localizedDescription)
            return []
        }
    }

    func fetch<T: ManagedObjectProtocol>(key: String, value: String) -> T? {

        let fetchResult: [T]

        do {
            fetchResult = try fetch(
                NSFetchRequest<T>(entityName: T.entity().name!).with(NSPredicate(format: "\(key) = \(value)"))
            )
        } catch {
            print(error.localizedDescription)
            return nil
        }

        if fetchResult.count == 0 {
            print("[ERROR] Unable to find object for key: '\(key)', value: '\(value)'!")
            return nil
        }

        if fetchResult.count > 1 {
            print("[ERROR] Multiple objects found for key: '\(key)', value: '\(value)'!")
            return nil
        }

        return fetchResult.first!
    }

    public func fetchOrInsert<T>(_ request: NSFetchRequest<T>) -> T? {

        if let entities = try? fetch(request), entities.count == 1,
            let entity = entities.first {
            return entity
        }

        if let entityDescription = request.entity,
            let entity = NSManagedObject(entity: entityDescription, insertInto: self) as? T {
            return entity
        }

        print("[ERROR] This should not happen!")
        return nil
    }

    // TODO: Add cache
    // https://developer.apple.com/library/content/documentation/Cocoa/Conceptual/CoreData/nsfetchedresultscontroller.html#//apple_ref/doc/uid/TP40001075-CH8-SW6
    // Fetch from CoreData, return in the form of a FetchedResultsController
    public func fetchedResultsController<T>(fetchRequest: NSFetchRequest<T>, sectionNameKeyPath: String? = nil, cacheName: String? = nil) -> NSFetchedResultsController<T> {
        return NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: self,
            sectionNameKeyPath: sectionNameKeyPath,
            cacheName: cacheName
        )
    }

}
