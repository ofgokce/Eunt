//
//  Registry.swift
//  
//
//  Created by Ömer Faruk Gökce on 7.10.2023.
//

import Foundation

public class Registry {
    
    let type: Routable.Type
    weak var parent: Registry?
    let children: [Registry]

    init(_ type: Routable.Type, children: [Registry] = []) {
        self.type = type
        self.children = children.removeDuplicates()
        for registry in self.children {
            registry.parent = parent
        }
    }
}

extension Registry: Hashable {
    
    public static func == (lhs: Registry, rhs: Registry) -> Bool {
        lhs.type == rhs.type && lhs.children == rhs.children
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine("\(type)")
        hasher.combine(children.hashValue)
    }
}

extension Array where Element == Registry {
    
    func flatten() -> [Registry] {
        var flatArray: [Registry] = []
        for registry in self {
            flatArray.append(registry)
            flatArray.append(contentsOf: registry.children.flatten())
        }
        return flatArray
    }
}
