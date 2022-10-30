//
//  MainBaseView.swift
//  Converter
//
//  Created by Misha Causur on 28.10.2022.
//

import UIKit.NSLayoutConstraint

final class MainBaseView: Viеw {
    
    var currencyButtonDidTapped: ((CurrencyButton) -> Void)?
    
    private let upperTextField = MainViewTextField()
    private let lowerTextField = MainViewTextField()
    private let button = UIFactory.createButton(with: .convert)
    
    override func configure() {
        super.configure()
        upperTextField.buttonDidTapped = { [weak self] in
            self?.currencyButtonDidTapped?(.upper)
        }
        lowerTextField.buttonDidTapped = { [weak self] in
            self?.currencyButtonDidTapped?(.lower)
        }
    }
    
    override func addViews() {
        addViews(upperTextField, lowerTextField, button)
        upperTextField.configureLabel(currency: "$")
        lowerTextField.configureLabel(currency: "gj")
    }
    
    override func layout() {
        [upperTextField, lowerTextField].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        let constraints = [
            upperTextField.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            upperTextField.topAnchor.constraint(equalTo: self.topAnchor),
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
    
//    func addTargetUpperTextField(_ target: Any?, buttonDidTapped: Selector) {
//        upperTextField.addTarget(target, buttonDidTapped: buttonDidTapped)
//    }
//    
//    func addTargetLowerTextField(_ target: Any?, buttonDidTapped: Selector) {
//        lowerTextField.addTarget(target, buttonDidTapped: buttonDidTapped)
//    }
}
