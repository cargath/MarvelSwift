//
//  NSFetchRequest+MarvelSwift.swift
//  MarvelSwift
//
//  Created by Carsten Könemann on 22.06.2019.
//  Copyright © 2019 cargath. All rights reserved.
//

import CoreData

extension NSFetchRequest {

    @objc func with(_ predicate: NSPredicate?) -> Self {
        self.predicate = predicate
        return self
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
