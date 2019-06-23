//
//  String+MarvelSwift.swift
//  MarvelSwift
//
//  Created by Carsten Könemann on 23.06.2019.
//  Copyright © 2019 cargath. All rights reserved.
//

import Foundation

extension String {

    var url: URL? {
        return URL(string: replacingOccurrences(of: "http:", with: "https:"))
    }

}
