//
//  MainViewTextField.swift
//  Converter
//
//  Created by Misha Causur on 29.10.2022.
//

import RxCocoa
import UIKit.NSLayoutConstraint

final class MainViewTextField: Viеw {
    
    var didTapButton: Signal<Void> {
        textFieldButton.rx
            .tap
            .asSignal()
    }
    
    var didEnterTextFieldValue: Signal<String> {
        textField.rx
            .text
            .compactMap { $0 }
            .asSignal(onErrorJustReturn: "")
    }

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
    
    override func addViews() {
        addViews(textField, circle, textFieldButton)
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
}
