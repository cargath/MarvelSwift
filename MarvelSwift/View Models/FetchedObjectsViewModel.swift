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

class FetchedObjectsViewModel<ResultType>: NSObject, BindableObject, NSFetchedResultsControllerDelegate where ResultType: NSFetchRequestResult {

    private let fetchedResultsController: NSFetchedResultsController<ResultType>

    var fetchedObjects: [ResultType] {
        return fetchedResultsController.fetchedObjects ?? []
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

    func configure(with fetchedResultsController: NSFetchedResultsController<ResultType>) {
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
