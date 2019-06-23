//
//  NSManagedObjectContext+MarvelSwift.swift
//  MarvelSwift
//
//  Created by Carsten Könemann on 23.06.2019.
//  Copyright © 2019 cargath. All rights reserved.
//

import CoreData

extension NSManagedObjectContext {

    func saveChanges() throws {
        if hasChanges {
            try save()
        }
    }

}

extension NSManagedObjectContext {

    func fetch<ResultType: NSManagedObject>(request: NSFetchRequest<ResultType>) throws -> ResultType {
        let results = try fetch(request) as [ResultType]
        switch results.count {
            case 0:
                throw MarvelSwiftError.missingObject(message: "Unable to find object '\(request.entityName ?? "nil")' for '\(request.predicate.debugDescription)'.")
            case 1:
                return results.first!
            default:
                throw MarvelSwiftError.multipleObjects(message: "Found multiple objects '\(request.entityName ?? "nil")' for '\(request.predicate.debugDescription)'.")
        }
    }

    func fetchOrInsert<ResultType: NSManagedObject>(_ request: NSFetchRequest<ResultType>) throws -> ResultType {
        do {
            return try fetch(request: request) as ResultType
        } catch MarvelSwiftError.missingObject {
            if let entityDescription = request.entity, let entity = NSManagedObject(entity: entityDescription, insertInto: self) as? ResultType {
                return entity
            } else {
                throw MarvelSwiftError.insertionFailure(message: "Should not happen.")
            }
        }
    }

}
