//
//  MainViewTextField.swift
//  Converter
//
//  Created by Misha Causur on 29.10.2022.
//

import UIKit.NSLayoutConstraint

final class MainViewTextField: Viеw {
    
    var buttonDidTapped: (() -> Void)?
    
    private let textField = UIFactory.createTextField(with: .enterValue)
    private let circle = CircleLabel().configure { $0.translatesAutoresizingMaskIntoConstraints = false }
    private let textFieldButton = UIFactory.createButton(with: .chooseCurrency, radius: 8, font: .small)
    
    override func addViews() {
        addViews(textField, circle, textFieldButton)
    }
    
    override func bindViews() {
        textFieldButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    override func layout() {

        let constraints = [
            textField.topAnchor.constraint(equalTo: topAnchor),
            textField.widthAnchor.constraint(equalToConstant: .defaultWidth - .defaultWidth/3 - 4),
            textField.heightAnchor.constraint(equalToConstant: .defaultHeight),
            textField.bottomAnchor.constraint(equalTo: bottomAnchor),
            textField.leadingAnchor.constraint(equalTo: leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: textFieldButton.leadingAnchor, constant: -4),
            circle.leadingAnchor.constraint(equalTo: textField.leadingAnchor),
            circle.centerYAnchor.constraint(equalTo: textField.centerYAnchor),
            textFieldButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            textFieldButton.widthAnchor.constraint(equalToConstant: .defaultWidth/3),
            textFieldButton.heightAnchor.constraint(equalToConstant: .defaultHeight),
            textFieldButton.centerYAnchor.constraint(equalTo: textField.centerYAnchor)]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    func configureLabel(currency: String) {
        circle.configureLabel(currency)
    }

    @objc private func buttonTapped() {
        buttonDidTapped?()
    }
}
