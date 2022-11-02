//
//  Layout.swift
//  Converter
//
//  Created by Misha Causur on 02.11.2022.
//

import UIKit.NSLayoutConstraint

protocol Layout {
    
    var constraints: [NSLayoutConstraint] { get }
}

extension NSLayoutConstraint: Layout {
    
    var constraints: [NSLayoutConstraint] { [self] }
}

extension Array: Layout where Element == NSLayoutConstraint {
    
    var constraints: [NSLayoutConstraint] { self }
}
