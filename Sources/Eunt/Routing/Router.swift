//
//  Router.swift
//  
//
//  Created by Ömer Faruk Gökce on 7.10.2023.
//

import UIKit

class Router {
    
    struct Error: Swift.Error { }
    
    public weak var origin: UIViewController!
    
    private let parentChildrenList: [(parent: RoutableOwner.Type, children: [Routable.Type])]
    
    private let childParentsList: [(child: Routable.Type, parents: [RoutableOwner.Type])]
    
    init(registrar: Registrar) {
        parentChildrenList = registrar.registries.toParentChildrenList()
        childParentsList = registrar.registries.toChildParentsList()
    }
    
    public func route(to route: Route) {
        DispatchQueue.main.async { [weak self] in
            guard let origin = self?.origin else { return } //TODO: log
            self?.route(to: route, from: origin)
        }
    }
    
    public func routeBack() {
        DispatchQueue.main.async { [weak self] in
            guard let origin = self?.origin else { return } //TODO: log
            self?.routeBack(from: origin)
        }
    }
    
    public func routeToRoot() {
        DispatchQueue.main.async { [weak self] in
            guard let origin = self?.origin else { return } //TODO: log
            self?.routeToRoot(from: origin)
        }
    }
    
    public func routeToBoot() {
        DispatchQueue.main.async { [weak self] in
            guard let origin = self?.origin else { return } //TODO: log
            self?.routeToBoot(from: origin)
        }
    }
    
    public func dismiss() {
        DispatchQueue.main.async { [weak self] in
            guard let origin = self?.origin else { return } //TODO: log
            self?.dismiss(origin)
        }
    }
}

// MARK: - Private methods
private extension Router {
    
    func route(to route: Route, from origin: UIViewController) {
        let routable = route.routable
        
        do {
            
            try pop(to: routable, from: origin)
            //log
        } catch {
            
            let parents = childParentsList
                .first { $0.child == type(of: routable) }?
                .parents
                .map { $0.init(with: routable) } ?? []
            
            do {
                try push(routable, with: parents, on: origin)
                //log
            } catch {
                
                let viewController: UIViewController
                
                if let parent = parents.first,
                   let entry = parentChildrenList.first(where: { $0.parent == type(of: parent) }) {
                    viewController = createRoutable(for: entry, with: routable).build()
                } else {
                    viewController = routable.build()
                }
                
                origin.present(viewController, animated: true)
                // log
            }
        }
    }
    
    func routeBack(from origin: UIViewController) {
        if let parent = origin.navigationController {
            if parent.viewControllers.first == origin {
                dismiss()
            } else {
                parent.popViewController(animated: true)
            }
        } else {
            dismiss()
        }
    }
    
    func routeToRoot(from viewController: UIViewController) {
        if let viewController = viewController as? UINavigationController {
            viewController.popToRootViewController(animated: true)
        } else if let viewController = viewController.navigationController {
            routeToRoot(from: viewController)
        } else {
            return
            //log
        }
    }
    
    func routeToBoot(from viewController: UIViewController) {
        viewController
            .view
            .window?
            .rootViewController?
            .presentedViewController?
            .dismiss(animated: true)
    }
    
    func dismiss(_ viewController: UIViewController) {
        if viewController.presentingViewController != nil {
            viewController.dismiss(animated: true)
        } else if let viewController = origin.tabBarController {
            dismiss(viewController)
        } else if let viewController = origin.navigationController {
            dismiss(viewController)
        }
    }
}

// MARK: - Routing methods
private extension Router {
    
    func pop(to routable: Routable, from origin: UIViewController) throws {
        if let origin = origin as? UITabBarController {
            try pop(to: routable, from: origin)
        } else if let origin = origin as? UINavigationController {
            try pop(to: routable, from: origin)
        } else if let origin = origin.navigationController {
            try pop(to: routable, from: origin)
        } else if let origin = origin.tabBarController {
            try pop(to: routable, from: origin)
        } else if let presenter = origin.presentingViewController {
            try pop(to: routable, from: presenter)
            origin.dismiss(animated: true)
        } else {
            throw Error()
        }
    }
    
    func pop(to routable: Routable, from origin: UITabBarController) throws {
        guard let viewControllers = origin.viewControllers else { throw Error() }
        for (index, viewController) in viewControllers.enumerated() {
            if viewController.routeIdentifier?.hashValue == routable.identifier.hashValue {
                origin.selectedIndex = index
                return
            }
            if let viewController = viewController as? UITabBarController {
                do {
                    try pop(to: routable, from: viewController)
                    origin.selectedIndex = index
                    return
                } catch {
                    continue
                }
            }
            if let viewController = viewController as? UINavigationController {
                do {
                    try pop(to: routable, from: viewController)
                    origin.selectedIndex = index
                    return
                } catch {
                    continue
                }
            }
        }
        if let presenter = origin.presentingViewController {
            try pop(to: routable, from: presenter)
            origin.dismiss(animated: true)
            return
        } else {
            throw Error()
        }
    }
    
    func pop(to routable: Routable, from origin: UINavigationController) throws {
        for viewController in origin.viewControllers {
            if viewController.routeIdentifier?.hashValue == routable.identifier.hashValue {
                origin.popToViewController(viewController, animated: true)
                return
            }
            if let viewController = viewController as? UITabBarController {
                do {
                    try pop(to: routable, from: viewController)
                    origin.popToViewController(viewController, animated: true)
                    return
                } catch {
                    continue
                }
            }
            if let viewController = viewController as? UINavigationController {
                do {
                    try pop(to: routable, from: viewController)
                    origin.popToViewController(viewController, animated: true)
                    return
                } catch {
                    continue
                }
            }
        }
        if let presenter = origin.presentingViewController {
            try pop(to: routable, from: presenter)
            origin.dismiss(animated: true)
            return
        } else {
            throw Error()
        }
    }
    
    func push(_ routable: Routable, with parents: [Routable], on origin: UIViewController) throws {
        if let origin = origin as? UITabBarController {
            try push(routable, with: parents, on: origin)
        } else if let origin = origin as? UINavigationController {
            try push(routable, with: parents, on: origin)
        } else if let origin = origin.navigationController {
            try push(routable, with: parents, on: origin)
        } else if let origin = origin.tabBarController {
            try push(routable, with: parents, on: origin)
        } else if let presenter = origin.presentingViewController {
            try push(routable, with: parents, on: presenter)
            origin.dismiss(animated: true)
        } else {
            throw Error()
        }
    }
    
    func push(_ routable: Routable, with parents: [Routable], on origin: UITabBarController) throws {
        guard let viewControllers = origin.viewControllers else { throw Error() }
        for (index, viewController) in viewControllers.enumerated() {
            do {
                if let viewController = viewController as? UITabBarController {
                    try push(routable, with: parents, on: viewController)
                } else if let viewController = viewController as? UINavigationController {
                    try push(routable, with: parents, on: viewController)
                } else {
                    continue
                }
                origin.selectedIndex = index
                return
            } catch {
                continue
            }
        }
        if let presenter = origin.presentingViewController {
            try push(routable, with: parents, on: presenter)
            origin.dismiss(animated: true)
            return
        } else {
            throw Error()
        }
    }
    
    func push(_ routable: Routable, with parents: [Routable], on origin: UINavigationController) throws {
        if parents.contains(where: { $0.identifier.hashValue == origin.routeIdentifier?.hashValue }) {
            origin.pushViewController(routable.build(), animated: true)
            return
        }
        for viewController in origin.viewControllers {
            do {
                if let viewController = viewController as? UITabBarController {
                    try push(routable, with: parents, on: viewController)
                } else if let viewController = viewController as? UINavigationController {
                    try push(routable, with: parents, on: viewController)
                } else {
                    continue
                }
                origin.popToViewController(viewController, animated: true)
                return
            } catch {
                continue
            }
        }
        if let presenter = origin.presentingViewController {
            try push(routable, with: parents, on: presenter)
            origin.dismiss(animated: true)
            return
        } else {
            throw Error()
        }
    }
    
    func present(_ routable: Routable, with parent: Routable?, on origin: UIViewController) throws {
        
        if let entry = parentChildrenList.first(where: { $0.parent == type(of: parent) }) {
            
            let parentRoutable = entry.parent.init(with: [ ]).build()
        } else {
            origin.present(routable.build(), animated: true)
        }
    }
    
    func createRoutable(for entry: (parent: RoutableOwner.Type, children: [Routable.Type]), with child: Routable) -> Routable {
        let routable: Routable
        
        // Check children of the parent first and create the parent
        if entry.children.isEmpty {
            routable = entry.parent.init(with: child)
        } else if let index = entry.children.firstIndex(where: { $0 == type(of: child) }) {
            var children = entry.children.removing(at: index).map(createRoutable(for:))
            children.insert(child, at: index)
            routable = entry.parent.init(with: children)
        } else {
            var children = entry.children.map(createRoutable(for:))
            children.append(child)
            routable = entry.parent.init(with: children)
        }
        
        // Check parent of the parent
        if let parent = childParentsList.first(where: { $0.child == type(of: routable) })?.parents.first,
           let entry = parentChildrenList.first(where: { $0.parent == parent}) {
            return createRoutable(for: entry, with: routable)
        } else {
            return routable
        }
    }
    
    func createRoutable(for routableType: Routable.Type) -> Routable {
        // Check if type is a parent
        if let entry = parentChildrenList.first(where: { $0.parent == routableType }) {
            return entry.parent.init(with: entry.children.map(createRoutable(for:)))
        } else {
            return routableType.init()
        }
    }
}
