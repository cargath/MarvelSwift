//
//  NSManagedObject+MarvelSwift.swift
//  MarvelSwift
//
//  Created by Carsten Könemann on 26.06.2019.
//  Copyright © 2019 cargath. All rights reserved.
//

import Combine
import CoreData

extension NSManagedObject {

    private func wasUpdated(in notification: Notification) throws -> Bool {
        if notification.didDelete(self) {
            throw MarvelSwiftError.objectDeleted(message: "The object has been deleted during observation.")
        }
        return notification.didUpdate(self)
    }

    func objectDidChangePublisher() -> AnyPublisher<Notification, Error>? {
        return managedObjectContext?
            .objectsDidChangePublisher()
            .tryFilter(wasUpdated)
            .eraseToAnyPublisher()
    }

}
