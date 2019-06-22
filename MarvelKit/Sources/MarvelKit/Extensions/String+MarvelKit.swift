//
//  String+MarvelKit.swift
//  MarvelKit
//
//  Created by Carsten Könemann on 22.06.2019.
//  Copyright © 2016 cargath. All rights reserved.
//

import CommonCrypto
import Foundation

extension String {

    var md5: String {

        let length = Int(CC_MD5_DIGEST_LENGTH)
        var digest = [UInt8](repeating: 0, count: length)

        if let data = self.data(using: .utf8) {
            _ = data.withUnsafeBytes { body -> String in
                CC_MD5(body.baseAddress, CC_LONG(data.count), &digest)
                return ""
            }
        }

        return (0 ..< length).reduce("") {
            $0 + String(format: "%02x", digest[$1])
        }
    }

}
