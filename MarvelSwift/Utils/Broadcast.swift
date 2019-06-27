//
//  Broadcast.swift
//  MarvelSwift
//
//  Created by Carsten Könemann on 27.06.2019.
//  Copyright © 2019 cargath. All rights reserved.
//

class Broadcast<Key, Value> where Key : Hashable {

    private var subscribers: [Key: [(Value) -> Void]] = [:]

    @discardableResult
    func add(subscriber: @escaping (Value) -> Void, for key: Key) -> Bool {

        if subscribers.keys.contains(key) {
            subscribers[key]?.append(subscriber)
            return false
        }

        subscribers[key] = [subscriber]
        return true
    }

    @discardableResult
    func send(value: Value, for key: Key) -> Bool {

        guard let subscribers = self.subscribers[key] else {
            return false
        }

        self.subscribers.removeValue(forKey: key)

        for subscriber in subscribers {
            subscriber(value)
        }

        return true
    }

}
