//
//  ResourceParameter.swift
//  MarvelKit
//
//  Created by Carsten Könemann on 15.05.16.
//  Copyright © 2016 cargath. All rights reserved.
//

import Foundation

public protocol ResourceParameterProtocol {

    var key: String { get }

    var value: String { get }

}

public extension ResourceParameterProtocol {

    var urlQueryItem: URLQueryItem {
        return URLQueryItem(name: key, value: value)
    }

}
