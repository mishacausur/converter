//
//  MainViewTextField.swift
//  Converter
//
//  Created by Misha Causur on 29.10.2022.
//

import UIKit.NSLayoutConstraint

final class MainViewTextField: Viеw {
    
    var buttonDidTapped: (() -> Void)?
    var valueDidEntered: ((String) -> Void)?
    var value: Double {
        get {
            Double(textField.text!) ?? .zero
        }
        set {
            DispatchQueue.main.async { [weak self] in
                guard !newValue.isZero else {
                    self?.textField.text = .empty
                    return
                }
                self?.textField.text = "\(newValue)"
            }
        }
    }
    private let textField = UIFactory.createTextField(with: .enterValue)
    private let circle = CircleLabel().configure { $0.translatesAutoresizingMaskIntoConstraints = false }
    private let textFieldButton = UIFactory.createButton(with: .chooseCurrency, radius: .smallCornerRadius, font: .small)
    
    override func addViews() {
        addViews(textField, circle, textFieldButton)
    }
    
    override func bindViews() {
        textFieldButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        textField.addTarget(self, action: #selector(editingDidEnded), for: .editingDidEnd)
        textField.addTarget(self, action: #selector(editingDidChanged), for: .editingChanged)

    }
    
    override func layout() {

        let constraints = [
            textField.topAnchor.constraint(equalTo: topAnchor),
            textField.widthAnchor.constraint(equalToConstant: .defaultWidth - .defaultWidth/3 + .smallInset),
            textField.heightAnchor.constraint(equalToConstant: .defaultHeight),
            textField.bottomAnchor.constraint(equalTo: bottomAnchor),
            textField.leadingAnchor.constraint(equalTo: leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: textFieldButton.leadingAnchor, constant: .smallInset),
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
    @objc private func editingDidEnded() {
        textField.resignFirstResponder()
        valueDidEntered?(textField.text!)
    }
    @objc private func editingDidChanged() {
        valueDidEntered?(textField.text!)
    }
}
