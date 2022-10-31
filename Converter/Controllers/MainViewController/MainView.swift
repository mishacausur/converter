//
//  MainView.swift
//  Converter
//
//  Created by Misha Causur on 28.10.2022.
//

import UIKit

final class MainView: Viеw {
    
    var currencyButtonDidTapped: ((CurrencyButton) -> Void)?
    var currencyValueDidEnter: ((CurrencyButton, String) -> Void)?
    
    private let view = MainBaseView().configure { $0.translatesAutoresizingMaskIntoConstraints = false }
    
    override func configure() {
        super.configure()
        backgroundColor = .white
    }
    
    override func bindViews() {
        view.currencyButtonDidTapped = { [weak self] in
            self?.currencyButtonDidTapped?($0)
        }
        view.currencyValueDidEnter = { [weak self] in
            self?.currencyValueDidEnter?($0, $1)
        }
    }
    
    override func addViews() {
        addViews(view)
    }
    
    override func layout() {
        [view.centerXAnchor.constraint(equalTo: centerXAnchor),
         view.centerYAnchor.constraint(equalTo: centerYAnchor)].forEach { $0.isActive = true }
    }
    
    func changeValueLabel(_ label: CurrencyButton, value: String) {
        view.setupCurrencyLabel(label, value: value)
    }

    func addTarget(_ target: Any?, buttonDidTapped: Selector) {
        view.addTarget(target, buttonDidTapped: buttonDidTapped)
    }
    
    func setupTextFieldValue(_ label: CurrencyButton, value: Double) {
        view.setupTextFieldValue(label, value: value)
    }
    
    func showButton(_ value: Bool) {
        view.showButton(value)
    }
}
