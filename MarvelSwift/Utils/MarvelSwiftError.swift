//
//  MarvelSwiftError.swift
//  MarvelSwift
//
//  Created by Carsten Könemann on 23.06.2019.
//  Copyright © 2019 cargath. All rights reserved.
//

import Foundation

enum MarvelSwiftError {

    case insertionFailure(message: String)
    case missingObject(message: String)
    case missingUniqueIdentifier(message: String)
    case multipleObjects(message: String)
    case observationFailure(message: String)

}

extension MarvelSwiftError: LocalizedError {

    /// A localized message describing what error occurred.
    public var errorDescription: String? {
        switch self {
            case let .insertionFailure(message):
                return message
            case let .missingObject(message):
                return message
            case let .missingUniqueIdentifier(message):
                return message
            case let .multipleObjects(message):
                return message
            case let .observationFailure(message):
                return message
        }
    }

    /// A localized message describing the reason for the failure.
    public var failureReason: String? {
        switch self {
            case .insertionFailure:
                return "Unable to insert object into managed object context. Should not happen."
            case .missingObject:
                return "Unable to find object in managed object context."
            case .missingUniqueIdentifier:
                return "Unable to insert or fetch an object without a unique identifier."
            case .multipleObjects:
                return "Found multiple objects matching the description in managed object context. Should be unique."
            case .observationFailure:
                return "The observed object has become invalid or has been deleted."
        }
    }

}
