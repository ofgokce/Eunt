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
