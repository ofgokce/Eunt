//
//  Routable.swift
//  
//
//  Created by Ömer Faruk Gökce on 7.10.2023.
//

import Foundation

public protocol RoutableOwner: Routable {
    
    var routables: [Routable] { get }
    
    init(with routables: [Routable])
    
}

extension RoutableOwner {
    
    public init() {
        self.init(with: [])
    }
    
    init(with routable: Routable) {
        self.init(with: [routable])
    }
}
