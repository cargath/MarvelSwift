//
//  SeriesEntity+MarvelSwift.swift
//  MarvelSwift
//
//  Created by Carsten Könemann on 23.06.2019.
//  Copyright © 2019 cargath. All rights reserved.
//

import Foundation
import CoreData
import MarvelKit

// MARK: - Fetch requests

extension SeriesEntity {

    static func fetchRequest(uniqueIdentifier: Int64) -> NSFetchRequest<SeriesEntity> {
        // Should return only one object and therefore doesn't require sorting
        return fetchRequest(key: "uniqueIdentifier", int: uniqueIdentifier).unsorted()
    }

}

// MARK: - Series Summary

extension SeriesEntity {

    @discardableResult static func updateOrInsert(with resource: MarvelKit.SeriesSummary, into context: NSManagedObjectContext) -> SeriesEntity? {

        guard let resourceIdentifier = resource.id else {
            print("[ERROR] Can't insert entity without valid resource id!")
            return nil
        }

        guard let series = context.fetchOrInsert(SeriesEntity.fetchRequest(uniqueIdentifier: Int64(resourceIdentifier))) else {
            print("[ERROR] Unable to fetch or insert entity!")
            return nil
        }

        series.uniqueIdentifier = Int64(resourceIdentifier)
        series.update(with: resource)
        return series
    }

    @discardableResult func update(with resource: MarvelKit.SeriesSummary) -> SeriesEntity {

        if let name = resource.name {
            self.title = name
        }

        return self
    }

}

// MARK: - Series

extension SeriesEntity {

    @discardableResult static func updateOrInsert(with resources: [MarvelKit.Series], into context: NSManagedObjectContext) -> [SeriesEntity] {
        return resources.compactMap { updateOrInsert(with: $0, into: context) }
    }

    @discardableResult static func updateOrInsert(with resource: MarvelKit.Series, into context: NSManagedObjectContext) -> SeriesEntity? {

        guard let resourceIdentifier = resource.id else {
            print("[ERROR] Can't insert entity without valid resource id!")
            return nil
        }

        guard let series = context.fetchOrInsert(SeriesEntity.fetchRequest(uniqueIdentifier: Int64(resourceIdentifier))) else {
            print("[ERROR] Unable to fetch or insert entity!")
            return nil
        }

        series.uniqueIdentifier = Int64(resourceIdentifier)
        series.update(with: resource)
        return series
    }

    @discardableResult func update(with resource: MarvelKit.Series) -> SeriesEntity {

        if let name = resource.title {
            self.title = name
        }

        if let startYear = resource.startYear {
            self.startYear = Int64(startYear)
        }

        if let endYear = resource.endYear {
            self.endYear = Int64(endYear)
        }

        if let thumbnailURLString = resource.thumbnail?.urlString(size: .standardMedium)?.replacingOccurrences(of: "http:", with: "https:"), thumbnailURLString.url != nil {
            self.thumbnailURLString = thumbnailURLString
        }

        return self
    }

}
