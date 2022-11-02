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
            .zero
        }
        set {
            setupValueTextField(newValue)
        }
    }
    private let textField = UIFactory.createTextField(with: .enterValue)
    private let circle = CircleLabel().configure { $0.translatesAutoresizingMaskIntoConstraints = false }
    private let textFieldButton = UIFactory.createButton(with: .chooseCurrency, radius: .smallCornerRadius, font: .small)
    
    override func configure() {
        super.configure()
        textField.delegate = self
    }
    
    override func addViews() {
        addViews(textField, circle, textFieldButton)
    }
    
    override func bindViews() {
        textFieldButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        textField.addTarget(self, action: #selector(editingDidEnded), for: .editingDidEnd)
        textField.addTarget(self, action: #selector(editingDidChanged), for: .editingChanged)

    }
    
    override func layout() {
        
        NSLayoutConstraint.activate  {
            textField.topAnchor.constraint(equalTo: topAnchor)
            textField.widthAnchor.constraint(equalToConstant: .defaultWidth - .defaultWidth/3 + .smallInset)
            textField.heightAnchor.constraint(equalToConstant: .defaultHeight)
            textField.bottomAnchor.constraint(equalTo: bottomAnchor)
            textField.leadingAnchor.constraint(equalTo: leadingAnchor)
            textField.trailingAnchor.constraint(equalTo: textFieldButton.leadingAnchor, constant: .smallInset)
            circle.leadingAnchor.constraint(equalTo: textField.leadingAnchor)
            circle.centerYAnchor.constraint(equalTo: textField.centerYAnchor)
            textFieldButton.trailingAnchor.constraint(equalTo: trailingAnchor)
            textFieldButton.widthAnchor.constraint(equalToConstant: .defaultWidth/3)
            textFieldButton.heightAnchor.constraint(equalToConstant: .defaultHeight)
            textFieldButton.centerYAnchor.constraint(equalTo: textField.centerYAnchor)
        }
    }
    
    func configureLabel(currency: String) {
        circle.configureLabel(currency)
    }
    
    func setupValueTextField(_ value: Double) {
        DispatchQueue.main.async { [weak self] in
            guard !value.isZero else {
                self?.textField.text = .empty
                return
            }
            self?.textField.text = "\(value)"
        }
    }
    
    @objc private func buttonTapped() {
        buttonDidTapped?()
    }
    @objc private func editingDidEnded() {
        textField.resignFirstResponder()
        guard let text = textField.text else { return }
        valueDidEntered?(text)
    }
    @objc private func editingDidChanged() {
        guard let text = textField.text else { return }
        valueDidEntered?(text)
    }
}

extension MainViewTextField: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return Int(string) != nil || string.isEmpty
    }
}
