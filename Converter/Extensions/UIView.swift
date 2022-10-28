//
//  UIView.swift
//  Converter
//
//  Created by Misha Causur on 28.10.2022.
//

import UIKit.UIView

extension UIView: Configurable {
    
    func addViews(_ views: UIView...) {
        views.forEach { addSubview($0) }
    }
}
