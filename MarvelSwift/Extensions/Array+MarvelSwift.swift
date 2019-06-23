//
//  Array+MarvelSwift.swift
//  MarvelSwift
//
//  Created by Carsten Könemann on 23.06.2019.
//  Copyright © 2019 cargath. All rights reserved.
//

extension Array {

    func chunks(_ chunkSize: Int) -> [[Element]] {
        return stride(from: 0, to: self.count, by: chunkSize).map {
            Array(self[$0 ..< Swift.min($0 + chunkSize, self.count)])
        }
    }

}
