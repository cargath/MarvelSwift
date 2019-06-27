//
//  ComicEntity+MarvelSwift.swift
//  MarvelSwift
//
//  Created by Carsten Könemann on 23.06.2019.
//  Copyright © 2019 cargath. All rights reserved.
//

import Foundation
import CoreData
import MarvelKit

extension ComicEntity {

    static func fetchRequest(uniqueIdentifier: Int64) -> NSFetchRequest<ComicEntity> {
        // Should return only one object and therefore doesn't require sorting
        return fetchRequest().with(key: "uniqueIdentifier", int64: uniqueIdentifier).unsorted()
    }

}

extension ComicEntity {

    static func allFetchRequest() -> NSFetchRequest<ComicEntity> {
        return fetchRequest().sorted(by: [
            NSSortDescriptor(ascending: "releaseDate"),
            NSSortDescriptor(ascending: "title")
        ])
    }

    static func solicitsFetchRequest() -> NSFetchRequest<ComicEntity> {
        return fetchRequest().with(format: "isPulled == false && series.isPulled == false").sorted(by: [
            NSSortDescriptor(ascending: "releaseDate"),
            NSSortDescriptor(ascending: "title")
        ])
    }

    static func pullsFetchRequest() -> NSFetchRequest<ComicEntity> {
        return fetchRequest().with(format: "isPulled == true || series.isPulled == true").sorted(by: [
            NSSortDescriptor(ascending: "releaseDate"),
            NSSortDescriptor(ascending: "title")
        ])
    }

}

extension ComicEntity {

    @discardableResult
    static func updateOrInsert(with resources: [MarvelKit.Comic], into context: NSManagedObjectContext) throws -> [ComicEntity] {
        return try resources.compactMap {
            try updateOrInsert(with: $0, into: context)
        }
    }

    @discardableResult
    static func updateOrInsert(with resource: MarvelKit.Comic, into context: NSManagedObjectContext) throws -> ComicEntity {

        guard let resourceIdentifier = resource.id else {
            throw MarvelSwiftError.missingUniqueIdentifier(message: "Can't insert entity without valid resource id.")
        }

        let comic = try context.fetchOrInsert(ComicEntity.fetchRequest(uniqueIdentifier: Int64(resourceIdentifier)))
        comic.uniqueIdentifier = Int64(resourceIdentifier)
        try comic.update(with: resource, in: context)
        return comic
    }

    @discardableResult
    func update(with resource: MarvelKit.Comic, in context: NSManagedObjectContext) throws -> ComicEntity {

        if let onsaleDate = resource.onsaleDate {
            self.releaseDate = onsaleDate
        }

        if let title = resource.title {
            self.title = title
        }

        if let text = resource.description {
            self.text = text
        }

        if let issueNumber = resource.issueNumber {
            self.issueNumber = Int64(issueNumber)
        }

        if let writer = resource.writer {
            self.writer = writer
        }

        if let artist = resource.penciler {
            self.artist = artist
        }

        if let colorArtist = resource.colorist {
            self.colorArtist = colorArtist
        }

        if let thumbnailURLString = resource.thumbnail?.urlString(size: .standardMedium)?.replacingOccurrences(of: "http:", with: "https:"), thumbnailURLString.url != nil {
            self.thumbnailURLString = thumbnailURLString
        }

        if let imageURLString = resource.thumbnail?.urlString(size: .standardFantastic)?.replacingOccurrences(of: "http:", with: "https:"), imageURLString.url != nil {
            self.imageURLString = imageURLString
        }

        if let seriesSummary = resource.series {
            let seriesEntity = try SeriesEntity.updateOrInsert(with: seriesSummary, into: context)
            series = seriesEntity
            seriesEntity.addToComics(self)
        }

        return self
    }

}

extension ComicEntity {

    @objc var section: String {
        return (releaseDate as Date?)?
            .localizedString(dateStyle: .long)
            .uppercased() ?? ""
    }

    var creators: String {
        return [writer, artist, colorArtist]
            .compactMap({ $0?.components(separatedBy: " ").last })
            .joined(separator: ", ")
    }

    var cleanedTitle: String {
        return title?
            .components(separatedBy: "(").first?
            .condensingWhitespace ?? ""
    }

    var cleanedText: String {
        return text?
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .condensingWhitespace ?? ""
    }

}
