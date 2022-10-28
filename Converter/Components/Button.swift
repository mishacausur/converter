//
//  Button.swift
//  Converter
//
//  Created by Misha Causur on 28.10.2022.
//

import UIKit.UIButton

final class Button: UIButton {
    
    var cornerRadius: CGFloat = 12
    var color: UIColor = Color.mainOrage
  
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(_ title: String) {
        translatesAutoresizingMaskIntoConstraints = false
        layer.masksToBounds = true
        layer.cornerRadius = cornerRadius
        backgroundColor = color
        setTitle(title, for: .normal)
        titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
    }
}

