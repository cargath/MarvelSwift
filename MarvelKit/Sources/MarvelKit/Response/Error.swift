//
//  Error.swift
//  MarvelKit
//
//  Created by Carsten Könemann on 15.05.16.
//  Copyright © 2016 cargath. All rights reserved.
//

import Foundation

// MARK: - Error

public struct Error: Codable {

    public let message: String

    public let code: String

    public init(message: String, code: String) {
        self.message = message
        self.code = code
    }

}

extension Error: LocalizedError {

    /// A localized message describing what error occurred.
    public var errorDescription: String? {
        return message
    }

    /// A localized message describing the reason for the failure.
    public var failureReason: String? {
        return code
    }

}
