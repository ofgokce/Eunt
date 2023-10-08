//
//  Routable.swift
//  
//
//  Created by Ömer Faruk Gökce on 7.10.2023.
//

import UIKit

public protocol Routable {
    
    var identifier: any Hashable { get }
    
    init()
    
    func build() -> UIViewController
    
}

extension Routable {
    public var identifier: any Hashable {
        "\(Self.self)"
    }
}
