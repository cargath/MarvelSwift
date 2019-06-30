//
//  NSFetchRequest+MarvelSwift.swift
//  MarvelSwift
//
//  Created by Carsten Könemann on 22.06.2019.
//  Copyright © 2019 cargath. All rights reserved.
//

import CoreData

extension NSFetchRequest {

    @objc func with(predicate: NSPredicate?) -> Self {
        self.predicate = predicate
        return self
    }

    @objc func with(format: String) -> Self {
        return with(predicate: NSPredicate(format: format))
    }

    @objc func with(key: String, bool value: Bool) -> Self {
        return with(predicate: NSPredicate(format: "\(key) == %@", NSNumber(booleanLiteral: value)))
    }

    @objc func with(key: String, int value: Int) -> Self {
        return with(predicate: NSPredicate(format: "\(key) == %@", NSNumber(integerLiteral: value)))
    }

    @objc func with(key: String, int64 value: Int64) -> Self {
        return with(predicate: NSPredicate(format: "\(key) == %@", NSNumber(value: value)))
    }

    @objc func with(key: String, string value: String) -> Self {
        return with(predicate: NSPredicate(format: "\(key) == '\(value)'"))
    }

    @objc func fetchBatchSize(_ fetchBatchSize: Int) -> Self {
        self.fetchBatchSize = fetchBatchSize
        return self
    }

    @objc func includesPendingChanges(_ includesPendingChanges: Bool) -> Self {
        self.includesPendingChanges = includesPendingChanges
        return self
    }

    @objc func sorted(by sortDescriptors: [NSSortDescriptor]?) -> Self {
        self.sortDescriptors = sortDescriptors
        return self
    }

    @objc func sorted(ascending key: String) -> Self {
        self.sortDescriptors = [NSSortDescriptor(key: key, ascending: true)]
        return self
    }

    @objc func sorted(descending key: String) -> Self {
        self.sortDescriptors = [NSSortDescriptor(key: key, ascending: false)]
        return self
    }

    @objc func unsorted() -> Self {
        self.sortDescriptors = []
        return self
    }

}
