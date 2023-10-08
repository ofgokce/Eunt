//
//  Registrar.swift
//  
//
//  Created by Ömer Faruk Gökce on 7.10.2023.
//

import Foundation

public protocol Registrar {
    
    @Builder<Registry> var registries: [Registry] { get }
    
}

public extension Registrar {
    
    func register(_ type: Routable.Type) -> Registry {
        .init(type)
    }
    
    func register(_ type: RoutableOwner.Type, @Builder<Registry> _ children: () -> [Registry]) -> Registry {
        .init(type, children: children())
    }
}

internal extension Registrar {
    
    func findParent(of type: Routable.Type) -> RoutableOwner? {
        
        if registries.contains(where: { $0.type == type }) { return nil }
        
        for registry in registries
        where registry.isParent(of: type) {
            
        }
    }
}
