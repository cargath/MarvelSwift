//
//  Notification+MarvelSwift.swift
//  MarvelSwift
//
//  Created by Carsten Könemann on 26.06.2019.
//  Copyright © 2019 cargath. All rights reserved.
//

import CoreData

extension Notification {

    func managedObjects(for key: String) -> Set<NSManagedObject> {
        return (userInfo?[key] as? Set<NSManagedObject>) ?? Set()
    }

}

extension Notification {

    var insertedManagedObjects: Set<NSManagedObject> {
        return managedObjects(for: NSInsertedObjectsKey)
    }

    var updatedManagedObjects: Set<NSManagedObject> {
        return managedObjects(for: NSUpdatedObjectsKey)
    }

    var deletedManagedObjects: Set<NSManagedObject> {
        return managedObjects(for: NSDeletedObjectsKey)
    }

    var refreshedManagedObjects: Set<NSManagedObject> {
        return managedObjects(for: NSRefreshedObjectsKey)
    }

    var invalidatedManagedObjects: Set<NSManagedObject> {
        return managedObjects(for: NSInvalidatedObjectsKey)
    }

}

extension Notification {

    func didInsert(_ object: NSManagedObject) -> Bool {
        return insertedManagedObjects
            .contains { $0 === object }
    }

    func didUpdate(_ object: NSManagedObject) -> Bool {
        return updatedManagedObjects
            .union(refreshedManagedObjects)
            .contains { $0 === object }
    }

    func didDelete(_ object: NSManagedObject) -> Bool {
        return deletedManagedObjects
            .union(invalidatedManagedObjects)
            .contains { $0 === object }
    }

}
