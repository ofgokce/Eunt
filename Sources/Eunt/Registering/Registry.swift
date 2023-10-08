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

extension Registry {
    func isParent(of type: Routable.Type) -> Bool {
        if children.contains(where: { $0.type == type }) {
            return true
        } else {
            return children.contains(where: { $0.isParent(of: type) })
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
    
    func toParentChildrenList() -> [(parent: RoutableOwner.Type, children: [Routable.Type])] {
        var list: [(parent: RoutableOwner.Type, children: [Routable.Type])] = []
        for registry in self {
            guard !registry.children.isEmpty,
                  let parent = registry.type as? RoutableOwner.Type else { continue }
            list.append((parent, registry.children.map(\.type)))
            list.append(contentsOf: registry.children.toParentChildrenList())
        }
        return list
    }
    
    func toChildParentsList() -> [(child: Routable.Type, parents: [RoutableOwner.Type])] {
        let parentChildrenList = self.toParentChildrenList()
        var list: [(child: Routable.Type, parents: [RoutableOwner.Type])] = []
        for entry in parentChildrenList {
            for child in entry.children {
                if let index = list.firstIndex(where: { $0.child == child }) {
                    if !list[index].parents.contains(where: { $0 == entry.parent }) {
                        var element = list.remove(at: index)
                        element.parents.append(entry.parent)
                        list.append(element)
                    }
                } else {
                    list.append((child, [entry.parent]))
                }
            }
        }
        return list
    }
}
