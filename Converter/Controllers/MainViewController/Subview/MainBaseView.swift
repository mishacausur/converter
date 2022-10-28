//
//  MainBaseView.swift
//  Converter
//
//  Created by Misha Causur on 28.10.2022.
//

import UIKit.NSLayoutConstraint

final class MainBaseView: Viеw {
    
    private let upperTextField = UIFactory.createTextField(with: .enterValue)
    private let upperCircle = CircleLabel().configure { $0.translatesAutoresizingMaskIntoConstraints = false }
    private let lowerTextField = UIFactory.createTextField(with: .enterValue)
    private let lowerCircle = CircleLabel().configure { $0.translatesAutoresizingMaskIntoConstraints = false }
    private let button = UIFactory.createButton(with: .convert)
    
    
    override func addViews() {
        addViews(upperTextField, upperCircle, lowerTextField, lowerCircle, button)
        upperCircle.configureLabel("$")
        lowerCircle.configureLabel("gj")
    }
    
    override func layout() {
        let constraints = [
            upperTextField.centerXAnchor.constraint(equalTo: centerXAnchor),
            upperTextField.topAnchor.constraint(equalTo: topAnchor),
            upperTextField.widthAnchor.constraint(equalToConstant: .defaultWidth),
            upperTextField.heightAnchor.constraint(equalToConstant: .defaultHeight),
            upperCircle.leadingAnchor.constraint(equalTo: upperTextField.leadingAnchor),
            upperCircle.centerYAnchor.constraint(equalTo: upperTextField.centerYAnchor),
            lowerTextField.centerXAnchor.constraint(equalTo: centerXAnchor),
            lowerTextField.topAnchor.constraint(equalTo: upperTextField.bottomAnchor, constant: .defaultInset),
            lowerTextField.widthAnchor.constraint(equalToConstant: .defaultWidth),
            lowerTextField.heightAnchor.constraint(equalToConstant: .defaultHeight),
            lowerCircle.leadingAnchor.constraint(equalTo: lowerTextField.leadingAnchor),
            lowerCircle.centerYAnchor.constraint(equalTo: lowerTextField.centerYAnchor),
            button.centerXAnchor.constraint(equalTo: centerXAnchor),
            button.topAnchor.constraint(equalTo: lowerTextField.bottomAnchor, constant: .defaultInset),
            button.bottomAnchor.constraint(equalTo: bottomAnchor),
            button.widthAnchor.constraint(equalToConstant: .defaultWidth),
            button.heightAnchor.constraint(equalToConstant: .defaultHeight)]
        
        NSLayoutConstraint.activate(constraints)
    }
}
