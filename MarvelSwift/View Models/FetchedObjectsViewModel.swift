//
//  FetchedObjectsViewModel.swift
//  MarvelSwift
//
//  Created by Carsten Könemann on 22.06.2019.
//  Copyright © 2019 cargath. All rights reserved.
//

import Combine
import CoreData
import SwiftUI

// MARK: - SectionInfo

struct SectionInfo<ResultType> where ResultType: NSFetchRequestResult {

    private let sectionInfo: NSFetchedResultsSectionInfo

    init(sectionInfo: NSFetchedResultsSectionInfo) {
        self.sectionInfo = sectionInfo
    }

    /// Name of the section.
    var name: String {
        sectionInfo.name
    }

    /// Title of the section (used when displaying the index).
    var indexTitle: String? {
        sectionInfo.indexTitle
    }

    /// Number of objects in section.
    var numberOfObjects: Int {
        sectionInfo.numberOfObjects
    }

    /// Returns the array of objects in the section.
    var objects: [ResultType] {
        (sectionInfo.objects as? [ResultType]) ?? []
    }

}

// MARK: - FetchedObjectsViewModel

class FetchedObjectsViewModel<ResultType>: NSObject, NSFetchedResultsControllerDelegate, BindableObject where ResultType: NSFetchRequestResult {

    private let fetchedResultsController: NSFetchedResultsController<ResultType>

    var fetchedObjects: [ResultType] {
        fetchedResultsController.fetchedObjects ?? []
    }

    var sections: [SectionInfo<ResultType>] {
        fetchedResultsController.sections?.map(SectionInfo.init) ?? []
    }

    var errorDescription: String?

    // MARK: BindableObject
    var didChange = PassthroughSubject<Void, Never>()

    init(fetchedResultsController: NSFetchedResultsController<ResultType>) {
        self.fetchedResultsController = fetchedResultsController
        // Should be called from subclasses of NSObject.
        super.init()
        // Configure the view model to receive updates from Core Data.
        configure(with: self.fetchedResultsController)
    }

    private func configure(with fetchedResultsController: NSFetchedResultsController<ResultType>) {
        fetchedResultsController.delegate = self
        // Load initial set of data.
        do {
            try fetchedResultsController.performFetch()
        } catch {
            // In case we want to present the error to the user.
            errorDescription = error.localizedDescription
        }
    }

    // MARK: NSFetchedResultsControllerDelegate
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        didChange.send()
    }

}
