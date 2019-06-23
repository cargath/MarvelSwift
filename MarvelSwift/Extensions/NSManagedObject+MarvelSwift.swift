//
//  NSManagedObject+MarvelSwift.swift
//  MarvelSwift
//
//  Created by Carsten Könemann on 23.06.2019.
//  Copyright © 2019 cargath. All rights reserved.
//

import CoreData

extension NSManagedObject {

    static func fetchRequest<T>(format: String) -> NSFetchRequest<T> {
        return fetchRequest().with(NSPredicate(format: format)) as! NSFetchRequest<T>
    }

    static func fetchRequest<T>(key: String, bool value: Bool) -> NSFetchRequest<T> {
        return fetchRequest().with(NSPredicate(format: "\(key) == %@", NSNumber(booleanLiteral: value))) as! NSFetchRequest<T>
    }

    static func fetchRequest<T>(key: String, int value: Int) -> NSFetchRequest<T> {
        return fetchRequest().with(NSPredicate(format: "\(key) == %@", NSNumber(integerLiteral: value))) as! NSFetchRequest<T>
    }

    static func fetchRequest<T>(key: String, int value: Int64) -> NSFetchRequest<T> {
        return fetchRequest().with(NSPredicate(format: "\(key) == %@", NSNumber(value: value))) as! NSFetchRequest<T>
    }

    static func fetchRequest<T>(key: String, string value: String) -> NSFetchRequest<T> {
        return fetchRequest().with(NSPredicate(format: "\(key) == '\(value)'")) as! NSFetchRequest<T>
    }

    func copyRequest() -> NSFetchRequest<NSFetchRequestResult> {
        return type(of: self).fetchRequest().with(NSPredicate(format: "self = %@", self))
    }

}
