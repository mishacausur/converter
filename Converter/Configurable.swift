//
//  Configurable.swift
//  Converter
//
//  Created by Misha Causur on 28.10.2022.
//

import Foundation
import UIKit

protocol Configurable {
}

extension Configurable where Self: UIView {
    
    @discardableResult
    func configure(_ block: (Self) throws -> Void) rethrows -> Self {
        try block(self)
        return self
    }
}
