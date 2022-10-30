//
//  MainView.swift
//  Converter
//
//  Created by Misha Causur on 28.10.2022.
//

import UIKit

final class MainView: Viеw {
    
    var currencyButtonDidTapped: ((CurrencyButton) -> Void)?

    private let view = MainBaseView().configure { $0.translatesAutoresizingMaskIntoConstraints = false }
    
    override func configure() {
        super.configure()
        backgroundColor = .white
        view.currencyButtonDidTapped = { [weak self] in
            self?.currencyButtonDidTapped?($0)
        }
    }
    
    override func addViews() {
        addViews(view)
    }
    
    override func layout() {
        [view.centerXAnchor.constraint(equalTo: centerXAnchor),
         view.centerYAnchor.constraint(equalTo: centerYAnchor)].forEach { $0.isActive = true }
    }
//
//    func addTargetUpperTextField(_ target: Any?, buttonDidTapped: Selector) {
//        view.addTargetUpperTextField(target, buttonDidTapped: buttonDidTapped)
//    }
//    
//    func addTargetLowerTextField(_ target: Any?, buttonDidTapped: Selector) {
//        view.addTargetLowerTextField(target, buttonDidTapped: buttonDidTapped)
//    }
}

enum CurrencyButton {
    case upper
    case lower
}
