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

extension Cancellable {

    /// Returns a type-erased version of the cancellable.
    func eraseToAnyCancellable() -> AnyCancellable {
        AnyCancellable(self)
    }

}

@dynamicMemberLookup
class ManagedObjectViewModel<ResultType>: BindableObject where ResultType: NSManagedObject {

    let managedObject: ResultType

    let autoSaves: Bool

    private var cancellable: AnyCancellable?

    // MARK: BindableObject
    var didChange = PassthroughSubject<Void, Never>()

    init(managedObject: ResultType, autoUpdates: Bool = false, autoSaves: Bool = false) {
        self.managedObject = managedObject
        self.autoSaves = autoSaves
        if autoUpdates {
            cancellable = managedObject
                .objectDidChangePublisher()?
                .sink(receiveValue: handle(objectDidChangeNotification:))
                .eraseToAnyCancellable()
        }
    }

    private func handle(objectDidChangeNotification: Notification) {
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
