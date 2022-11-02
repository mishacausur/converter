//
//  NSLayoutConstraint.swift
//  Converter
//
//  Created by Misha Causur on 02.11.2022.
//

import UIKit.NSLayoutConstraint

extension NSLayoutConstraint {

    static func activate(@ConstraintBuilder constraints: () -> [NSLayoutConstraint]) {
        activate(constraints())
    }
}
