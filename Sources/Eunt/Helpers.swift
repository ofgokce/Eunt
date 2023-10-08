//
//  File.swift
//  
//
//  Created by Ömer Faruk Gökce on 26.09.2023.
//

import UIKit

@resultBuilder
struct Builder<T> {
    static func buildBlock(_ components: T...) -> [T] {
        components
    }
}

class ClassWrapper<T> {
    var wrappedValue: T
    
    init(wrappedValue: T) {
        self.wrappedValue = wrappedValue
    }
}

struct WeakMapper<C: AnyObject, T> {
    private let map: NSMapTable<C, ClassWrapper<T>>
    
    init() {
        map = .init(keyOptions: .weakMemory, valueOptions: .strongMemory)
    }
    
    func get(for key: C?) -> T? {
        map.object(forKey: key)?.wrappedValue
    }
    
    func set(_ value: T?, for key: C?) {
        if let value {
            map.setObject(.init(wrappedValue: value), forKey: key)
        } else {
            map.removeObject(forKey: key)
        }
    }
}
