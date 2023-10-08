//
//  Routable.swift
//  
//
//  Created by Ömer Faruk Gökce on 7.10.2023.
//

import Foundation

public protocol RoutableOwner: Routable {
    
    init(with routables: [Routable])
    
}

extension RoutableOwner {
    
    init(with routable: Routable) {
        self.init(with: [routable])
    }
}
