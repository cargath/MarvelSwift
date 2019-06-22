//
//  JSONDecoder+MarvelKit.swift
//  MarvelKit
//
//  Created by Carsten Könemann on 23.06.2019.
//  Copyright © 2016 cargath. All rights reserved.
//

import Foundation

extension JSONDecoder {

    func resource<Resource>(from data: Data) throws -> DataWrapper<DataContainer<Resource>> {
        do {
            // Try to decode the data
            let dataWrapper = try decode(DataWrapper<DataContainer<Resource>>.self, from: data)
            // Sometimes the decoded data represents an error
            if let code = dataWrapper.code, code >= 300 {
                throw MarvelKit.Error(message: dataWrapper.status ?? "Unknown", code: String(code))
            }
            // This is the happy case
            return dataWrapper
        } catch {
            // Sometimes we can't decode the resource, because the data represents a differently formatted error
            if let error = try? decode(MarvelKit.Error.self, from: data) {
                throw error
            }
            // If all else fails, throw the DecodingError
            throw error
        }
    }

}
