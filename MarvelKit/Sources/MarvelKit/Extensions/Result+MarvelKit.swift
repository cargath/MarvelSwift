//
//  Result+MarvelKit.swift
//  MarvelKit
//
//  Created by Carsten Könemann on 23.06.2019.
//  Copyright © 2016 cargath. All rights reserved.
//

import Foundation

extension Result where Success == Data {

    func resource<Resource>(with decoder: JSONDecoder = .init()) -> Result<DataWrapper<DataContainer<Resource>>, Swift.Error> {
        do {
            let data = try get()
            let dataWrapper = try decoder.resource(from: data) as DataWrapper<DataContainer<Resource>>
            return .success(dataWrapper)
        } catch {
            return .failure(error)
        }
    }

}
