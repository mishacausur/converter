//
//  View.swift
//  Converter
//
//  Created by Misha Causur on 28.10.2022.
//

import UIKit.UIView

class Viеw: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    func configure() {
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
