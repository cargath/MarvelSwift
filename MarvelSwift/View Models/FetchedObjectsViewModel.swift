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

class FetchedObjectsViewModel<ResultType>: NSObject, NSFetchedResultsControllerDelegate, BindableObject where ResultType: NSFetchRequestResult {

    var didChange = PassthroughSubject<Void, Never>()

    var fetchedResultsController: NSFetchedResultsController<ResultType> {
        didSet {
            configure(with: fetchedResultsController)
        }
    }

    var fetchedObjects: [ResultType] {
        return fetchedResultsController.fetchedObjects ?? []
    }

    init(fetchedResultsController: NSFetchedResultsController<ResultType>) {
        self.fetchedResultsController = fetchedResultsController
        // Because NSObject
        super.init()
        // Because didSet doesn't get called from initializers
        configure(with: self.fetchedResultsController)
    }

    func configure(with fetchedResultsController: NSFetchedResultsController<ResultType>) {
        fetchedResultsController.delegate = self
        // TODO: Improve error handling
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("FOOBAR: \(error.localizedDescription)")
        }
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        didChange.send()
    }

}
