//
//  CircleLabel.swift
//  Converter
//
//  Created by Misha Causur on 28.10.2022.
//

import UIKit

final class CircleLabel: Viеw {
    
    let backView = UIView()
    let view = UIView()
    let label = UILabel().configure {
        $0.textColor = Color.white
        $0.font = .systemFont(ofSize: 24, weight: .bold)
    }
    
    private(set) var value: String? {
        get {
            label.text
        }
        set {
            label.text = newValue
        }
    }
    
    override func configure() {
        super.configure()
        view.layer.cornerRadius = 18
        view.backgroundColor = Color.mainOrage
        backView.layer.cornerRadius = 22
        backView.backgroundColor = Color.white
    }
    
    override func addViews() {
        addViews(backView, view, label)
    }
    
    override func layout() {
        [backView, view, label].forEach { $0.configure { $0.translatesAutoresizingMaskIntoConstraints = false } }
        [backView.centerXAnchor.constraint(equalTo: centerXAnchor),
         backView.centerYAnchor.constraint(equalTo: centerYAnchor),
         backView.widthAnchor.constraint(equalToConstant: 44),
         backView.heightAnchor.constraint(equalToConstant: 44),
         view.centerXAnchor.constraint(equalTo: centerXAnchor),
         view.centerYAnchor.constraint(equalTo: centerYAnchor),
         view.widthAnchor.constraint(equalToConstant: 36),
         view.heightAnchor.constraint(equalToConstant: 36),
         label.centerXAnchor.constraint(equalTo: centerXAnchor),
         label.centerYAnchor.constraint(equalTo: centerYAnchor)].forEach { $0.isActive = true }
    }
    
    func configureLabel(_ currency: String) {
        guard currency.count == 1 else {
            value = .rubleSign
            return
        }
        value = currency
    }
}
