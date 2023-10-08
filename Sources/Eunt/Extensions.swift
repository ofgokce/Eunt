//
//  File.swift
//  
//
//  Created by Ömer Faruk Gökce on 25.09.2023.
//

import UIKit

extension Sequence where Element: Hashable {
    func removeDuplicates() -> [Element] {
        var seen = Set<Element>()
        return self.filter { seen.insert($0).inserted }
    }
    
    func forEach(_ body: (Int, Element) -> Void) {
        for (index, element) in self.enumerated() {
            body(index, element)
        }
    }
}

extension Array {
    func removing(at index: Int) -> Self {
        var array = self
        array.remove(at: index)
        return array
    }
}

extension Array where Element: UIViewController {
    func first(with identifier: any Hashable) -> UIViewController? {
        self.first(where: { $0.routeIdentifier?.hashValue == identifier.hashValue })
    }
}
