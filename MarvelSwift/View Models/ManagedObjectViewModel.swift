//
//  ManagedObjectViewModel.swift
//  MarvelSwift
//
//  Created by Carsten Könemann on 24.06.2019.
//  Copyright © 2019 cargath. All rights reserved.
//

import Combine
import CoreData
import SwiftUI

extension NSManagedObjectContext {

    func objectsDidChangePublisher(notificationCenter: NotificationCenter = .default) -> NotificationCenter.Publisher {
        return notificationCenter.publisher(for: .NSManagedObjectContextObjectsDidChange, object: self)
    }

}

extension Cancellable {

    func eraseToAnyCancellable() -> AnyCancellable {
        return AnyCancellable(self)
    }

}

@dynamicMemberLookup
class ManagedObjectViewModel<ResultType>: BindableObject where ResultType: NSManagedObject {

    private let managedObject: ResultType

    private let autoSaves: Bool

    private var cancellable: AnyCancellable?

    // MARK: BindableObject
    var didChange = PassthroughSubject<Void, Never>()

    init(managedObject: ResultType, autoUpdates: Bool = false, autoSaves: Bool = false) {
        self.managedObject = managedObject
        self.autoSaves = autoSaves
        if autoUpdates {
            configure(with: managedObject)
        }
    }

    func configure(with managedObject: ResultType) {
        if let managedObjectContext = managedObject.managedObjectContext {
            configure(with: managedObject, in: managedObjectContext)
        } else {
            fatalError("Cannot observe a managed object without a valid context!")
        }
    }

    func configure(with managedObject: ResultType, in managedObjectContext: NSManagedObjectContext) {
        cancellable = managedObjectContext
            .objectsDidChangePublisher()
            .map(ObjectsDidChangeNotification.init)
            .tryMap { notification in
                if notification.didDelete(object: managedObject) {
                    throw MarvelSwiftError.observationFailure(message: "Object has been deleted during observation. Cancelling observation.")
                } else {
                    return notification
                }
            }
            .filter { $0.didUpdate(object: managedObject) }
            .sink(receiveValue: receiver(value:))
            .eraseToAnyCancellable()
    }

    func receiver(value: ObjectsDidChangeNotification) {
        didChange.send()
    }

    // MARK: @dynamicMemberLookup
    subscript<T>(dynamicMember keyPath: ReferenceWritableKeyPath<ResultType, T>) -> T {
        get {
            managedObject[keyPath: keyPath]
        }
        set {
            managedObject.managedObjectContext?.performAndWait { [unowned self] in
                managedObject[keyPath: keyPath] = newValue
                if self.autoSaves {
                    managedObject.managedObjectContext?.saveChangesOrRollback()
                }
            }
        }
    }

}
