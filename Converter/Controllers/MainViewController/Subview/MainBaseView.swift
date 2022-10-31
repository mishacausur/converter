//
//  MainBaseView.swift
//  Converter
//
//  Created by Misha Causur on 28.10.2022.
//

import UIKit.NSLayoutConstraint

final class MainBaseView: Viеw {
    
    var currencyButtonDidTapped: ((CurrencyButton) -> Void)?
    var currencyValueDidEnter: ((CurrencyButton, String) -> Void)?
    
    private let title = UILabel().configure {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = .mainViewTitle
        $0.font = .systemFont(ofSize: .largeFontSize, weight: .bold)
    }
    private let upperTextField = MainViewTextField()
    private let lowerTextField = MainViewTextField()
    private let button = UIFactory.createButton(with: .convert).configure { $0.isHidden = true }
    
    override func bindViews() {
        
        upperTextField.buttonDidTapped = { [weak self] in
            self?.currencyButtonDidTapped?(.upper)
        }
        lowerTextField.buttonDidTapped = { [weak self] in
            self?.currencyButtonDidTapped?(.lower)
        }
        upperTextField.valueDidEntered = { [weak self] in
            self?.currencyValueDidEnter?(.upper, $0)
        }
        lowerTextField.valueDidEntered = { [weak self] in
            self?.currencyValueDidEnter?(.lower, $0)
        }
    }
    
    override func addViews() {
        addViews(title, upperTextField, lowerTextField, button)
    }
    
    override func layout() {
        [upperTextField, lowerTextField].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        let constraints = [
            title.topAnchor.constraint(equalTo: topAnchor),
            title.centerXAnchor.constraint(equalTo: centerXAnchor),
            upperTextField.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            upperTextField.topAnchor.constraint(equalTo: title.bottomAnchor, constant: .titleInset),
            upperTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            upperTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            lowerTextField.centerXAnchor.constraint(equalTo: centerXAnchor),
            lowerTextField.topAnchor.constraint(equalTo: upperTextField.bottomAnchor, constant: .defaultInset),
            self.widthAnchor.constraint(greaterThanOrEqualToConstant: .defaultWidth),
            button.centerXAnchor.constraint(equalTo: centerXAnchor),
            button.topAnchor.constraint(equalTo: lowerTextField.bottomAnchor, constant: .defaultInset),
            button.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            button.widthAnchor.constraint(equalToConstant: .defaultWidth),
            button.heightAnchor.constraint(equalToConstant: .defaultHeight)]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    func setupCurrencyLabel(_ label: CurrencyButton, value: String) {
        switch label {
        case .upper:
            upperTextField.configureLabel(currency: value)
        case .lower:
            lowerTextField.configureLabel(currency: value)
        }
    }
    
    func addTarget(_ target: Any?, buttonDidTapped: Selector) {
        button.addTarget(target, action: buttonDidTapped, for: .touchUpInside)
    }
    
    func setupTextFieldValue(_ label: CurrencyButton, value: Double) {
        switch label {
        case .upper:
            upperTextField.value = value
        case .lower:
            lowerTextField.value = value
        }
    }
    
    func showButton(_ value: Bool) {
        button.isHidden = !value
    }
}
