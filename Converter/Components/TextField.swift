//
//  TextField.swift
//  Converter
//
//  Created by Misha Causur on 28.10.2022.
//

import UIKit.UITextField

final class TextField: UITextField {
    
    var cornerRadius: CGFloat = 12
  
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.textRect(forBounds: bounds)
        rect.origin.x += 26
        return rect
    }
    
    override func caretRect(for position: UITextPosition) -> CGRect {
        var rect = super.caretRect(for: position)
        rect.origin.x += 26
        return rect
    }
    
    func configure(_ placeHolder: String) {
        translatesAutoresizingMaskIntoConstraints = false
        layer.masksToBounds = true
        layer.cornerRadius = cornerRadius
        layer.borderColor = Color.gray.cgColor
        layer.borderWidth = 0.5
        placeholder = placeHolder
    }
}
