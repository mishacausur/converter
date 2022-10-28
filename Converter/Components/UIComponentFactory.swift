//
//  UIComponentFactory.swift
//  Converter
//
//  Created by Misha Causur on 28.10.2022.
//

import UIKit

struct UIFactory {
    
    static func createButton(with title: String, radius: CGFloat = 12, font: Button.Font = .regular) -> Button {
        let button = Button()
        button.cornerRadius = radius
        button.configure(title, font: font)
        return button
    }
    
    static func createTextField(with placeHolder: String) -> TextField {
        let textField = TextField()
        textField.configure(placeHolder)
        return textField
    }
}
