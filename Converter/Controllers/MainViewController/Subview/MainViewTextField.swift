//
//  MainViewTextField.swift
//  Converter
//
//  Created by Misha Causur on 29.10.2022.
//

import UIKit.NSLayoutConstraint

final class MainViewTextField: Viеw {
    private let textField = UIFactory.createTextField(with: .enterValue)
    private let circle = CircleLabel().configure { $0.translatesAutoresizingMaskIntoConstraints = false }
    private let textFieldButton = UIFactory.createButton(with: .chooseCurrency, radius: 8, font: .small)
    
    override func addViews() {
        addViews(textField, circle, textFieldButton)
    }
    
    override func layout() {

        let constraints = [
            textField.centerXAnchor.constraint(equalTo: centerXAnchor),
            textField.topAnchor.constraint(equalTo: topAnchor),
            textField.widthAnchor.constraint(equalToConstant: .defaultWidth),
            textField.heightAnchor.constraint(equalToConstant: .defaultHeight),
            textField.bottomAnchor.constraint(equalTo: bottomAnchor),
            circle.leadingAnchor.constraint(equalTo: textField.leadingAnchor),
            circle.centerYAnchor.constraint(equalTo: textField.centerYAnchor),
            textFieldButton.trailingAnchor.constraint(equalTo: textField.trailingAnchor, constant: -4),
            textFieldButton.widthAnchor.constraint(equalToConstant: .defaultWidth/3),
            textFieldButton.heightAnchor.constraint(equalToConstant: .defaultHeight - 8),
            textFieldButton.centerYAnchor.constraint(equalTo: textField.centerYAnchor)]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    func configureLabel(currency: String) {
        circle.configureLabel(currency)
    }

    func addTarget(_ target: Any?, buttonDidTapped: Selector) {
        textFieldButton.addTarget(target, action: buttonDidTapped, for: .touchUpInside)
    }
}
