//
//  Summary.swift
//  MarvelKit
//
//  Created by Carsten Könemann on 29.04.16.
//  Copyright © 2016 cargath. All rights reserved.
//

import Foundation

// MARK: - Summary interface

public protocol SummaryProtocol: Codable {

    var resourceURI: String? { get }

    var name: String? { get }

}

// MARK: - SummaryProtocol + resource identifier

public extension SummaryProtocol {

    var id: Int? {
        if let resourceURI = (resourceURI as NSString?), let resourceIdentifier = Int(resourceURI.lastPathComponent) {
            return resourceIdentifier
        } else {
            return nil
        }
    }

}
