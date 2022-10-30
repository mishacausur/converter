//
//  TextField.swift
//  Converter
//
//  Created by Misha Causur on 28.10.2022.
//

import UIKit.UITextField

final class TextField: UITextField {
    
    var cornerRadius: CGFloat = .regularCornerRadius
  
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(_ placeHolder: String) {
        translatesAutoresizingMaskIntoConstraints = false
        layer.masksToBounds = true
        layer.cornerRadius = cornerRadius
        layer.borderColor = Color.gray.cgColor
        layer.borderWidth = .defaultBorderWidth
        placeholder = placeHolder
        keyboardType = .numberPad
        textAlignment = .center
    }
}
