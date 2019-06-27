//
//  Cache.swift
//  MarvelSwift
//
//  Created by Carsten Könemann on 27.06.2019.
//  Copyright © 2019 cargath. All rights reserved.
//

import Foundation

/// A typesafe wrapper around NSCache that makes it accessible via Swifts subscript.
class Cache<Key, Value> where Key: AnyObject, Value: AnyObject {

    private let cache = NSCache<Key, Value>()

    subscript(key: Key) -> Value? {
        get {
            return cache.object(forKey: key)
        }
        set {
            if let newValue = newValue {
                cache.setObject(newValue, forKey: key)
            } else {
                cache.removeObject(forKey: key)
            }
        }
    }

}

/// Adds bridging from URL to NSURL when accessing the cache via subscribt.
extension Cache where Key == NSURL {

    subscript(url: URL) -> Value? {
        get {
            return cache.object(forKey: url as NSURL)
        }
        set {
            if let newValue = newValue {
                cache.setObject(newValue, forKey: url as NSURL)
            } else {
                cache.removeObject(forKey: url as NSURL)
            }
        }
    }

}
