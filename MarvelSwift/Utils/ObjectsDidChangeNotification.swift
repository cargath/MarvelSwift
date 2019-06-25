//
//  ObjectsDidChangeNotification.swift
//  MarvelSwift
//
//  Created by Carsten Könemann on 24.06.2019.
//  Copyright © 2019 cargath. All rights reserved.
//

import CoreData

public struct ObjectsDidChangeNotification {

    private let notification: Notification

    init(notification: Notification) {
        assert(notification.name == .NSManagedObjectContextObjectsDidChange)
        self.notification = notification
    }

    private func objects(forKey key: String) -> Set<NSManagedObject> {
        return ((notification as Notification).userInfo?[key] as? Set<NSManagedObject>) ?? Set()
    }

    public var insertedObjects: Set<NSManagedObject> {
        return objects(forKey: NSInsertedObjectsKey)
    }

    public var updatedObjects: Set<NSManagedObject> {
        return objects(forKey: NSUpdatedObjectsKey)
    }

    public var deletedObjects: Set<NSManagedObject> {
        return objects(forKey: NSDeletedObjectsKey)
    }

    public var refreshedObjects: Set<NSManagedObject> {
        return objects(forKey: NSRefreshedObjectsKey)
    }

    public var invalidatedObjects: Set<NSManagedObject> {
        return objects(forKey: NSInvalidatedObjectsKey)
    }

}

extension ObjectsDidChangeNotification {

    public func didInsert(object: NSManagedObject) -> Bool {
        return insertedObjects.contains { $0 === object }
    }

    public func didUpdate(object: NSManagedObject) -> Bool {
        return updatedObjects.union(refreshedObjects).contains { $0 === object }
    }

    public func didDelete(object: NSManagedObject) -> Bool {
        return deletedObjects.union(invalidatedObjects).contains { $0 === object }
    }

}
