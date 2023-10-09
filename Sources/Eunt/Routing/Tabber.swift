//
//  Routable.swift
//  
//
//  Created by Ömer Faruk Gökce on 7.10.2023.
//

import UIKit

public protocol Tabber: Routable {
    
    init(root: [Routable])
    
    func build() -> UITabBarController
    
}

public extension Tabber {
    init() {
        self.init(root: [])
    }
    func build() -> UIViewController {
        build()
    }
}
