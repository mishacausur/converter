//
//  Configurable.swift
//  Converter
//
//  Created by Misha Causur on 28.10.2022.
//

import Foundation

protocol Configurable {
}

extension Configurable where Self: AnyObject {
    func configure(_ block: (Self) throws -> Void) rethrows -> Self {
        try block(self)
        return self
    }
}

extension NSObject: Configurable {
}
