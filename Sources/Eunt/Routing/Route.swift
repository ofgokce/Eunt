//
//  File.swift
//  
//
//  Created by Ömer Faruk Gökce on 7.10.2023.
//

import UIKit

public struct Route {
    
    let routable: Routable
    
    private let presentation: UIModalPresentationStyle
    private let transition: UIModalTransitionStyle
    
    public init(_ routable: Routable,
                presentation: UIModalPresentationStyle = .overFullScreen,
                transition: UIModalTransitionStyle = .coverVertical) {
        self.routable = routable
        self.presentation = presentation
        self.transition = transition
    }
    
    func build() -> UIViewController {
        let route = routable.build()
        route.routeIdentifier = routable.identifier
        route.modalPresentationStyle = presentation
        route.modalTransitionStyle = transition
        return route
    }
}

extension UIViewController {

    private static var identifierMap = WeakMapper<UIViewController, any Hashable>()

    var routeIdentifier: (any Hashable)? {
        get { UIViewController.identifierMap.get(for: self) }
        set { UIViewController.identifierMap.set(newValue, for: self) }
    }
}
