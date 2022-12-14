//
//  CircleLabel.swift
//  Converter
//
//  Created by Misha Causur on 28.10.2022.
//

import UIKit

final class CircleLabel: Viеw {
    
    private let backView = UIView()
    private let view = UIView()
    private let label = UILabel().configure {
        $0.textColor = Color.white
        $0.font = .systemFont(ofSize: .smallFontSize, weight: .bold)
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
        view.layer.cornerRadius = .circleRadius
        view.backgroundColor = Color.mainOrage
        backView.layer.cornerRadius = .bigCircleRadius
        backView.backgroundColor = Color.white
    }
    
    override func addViews() {
        addViews(backView, view, label)
    }
    
    override func layout() {
        [backView, view, label].forEach { $0.configure { $0.translatesAutoresizingMaskIntoConstraints = false } }
        [backView.centerXAnchor.constraint(equalTo: centerXAnchor),
         backView.centerYAnchor.constraint(equalTo: centerYAnchor),
         backView.widthAnchor.constraint(equalToConstant: .bigCircleSize),
         backView.heightAnchor.constraint(equalToConstant: .bigCircleSize),
         view.centerXAnchor.constraint(equalTo: centerXAnchor),
         view.centerYAnchor.constraint(equalTo: centerYAnchor),
         view.widthAnchor.constraint(equalToConstant: .circleSize),
         view.heightAnchor.constraint(equalToConstant: .circleSize),
         label.centerXAnchor.constraint(equalTo: centerXAnchor),
         label.centerYAnchor.constraint(equalTo: centerYAnchor)].forEach { $0.isActive = true }
    }
    
    func configureLabel(_ currency: String) {
        guard currency.count == 3 else {
            value = .empty
            return
        }
        value = currency
    }
}
