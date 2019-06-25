//
//  NSSortDescriptor.swift
//  MarvelSwift
//
//  Created by Carsten Könemann on 24.06.2019.
//  Copyright © 2019 cargath. All rights reserved.
//

import Foundation

public extension NSSortDescriptor {

    convenience init(ascending key: String) {
        self.init(key: key, ascending: true)
    }

    convenience init(descending key: String) {
        self.init(key: key, ascending: false)
    }

}
