//
//  File.swift
//  
//
//  Created by Ömer Faruk Gökce on 8.10.2023.
//

import UIKit

public protocol Navigator: Routable {

    init(root: Routable?, shouldRouteTo: Routable?)

    func build() -> UINavigationController
}

public extension Navigator {

    init() {
        self.init(root: nil, shouldRouteTo: nil)
    }

    init(root: Routable) {
        self.init(root: root, shouldRouteTo: nil)
    }

    func build() -> UIViewController {
        build()
    }
}
