//
//  String+MarvelSwift.swift
//  MarvelSwift
//
//  Created by Carsten Könemann on 23.06.2019.
//  Copyright © 2019 cargath. All rights reserved.
//

import Foundation

extension String {

    var condensingWhitespace: String {
        components(separatedBy: .whitespaces)
            .filter { !$0.isEmpty }
            .joined(separator: " ")
    }

    var localized: String {
        NSLocalizedString(self, comment: "")
    }

    var url: URL? {
        URL(string: replacingOccurrences(of: "http:", with: "https:"))
    }

}
