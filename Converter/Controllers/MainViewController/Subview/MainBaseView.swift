//
//  MainBaseView.swift
//  Converter
//
//  Created by Misha Causur on 28.10.2022.
//

import UIKit.NSLayoutConstraint

final class MainBaseView: Viеw {
    
    private let upperTextField = MainViewTextField()
    private let lowerTextField = MainViewTextField()
    private let button = UIFactory.createButton(with: .convert)
    
    
    override func addViews() {
        addViews(upperTextField, lowerTextField, button)
        upperTextField.configureLabel(currency: "$")
        lowerTextField.configureLabel(currency: "gj")
    }
    
    override func layout() {
        [upperTextField, lowerTextField].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        let constraints = [
            upperTextField.centerXAnchor.constraint(equalTo: centerXAnchor),
            upperTextField.topAnchor.constraint(equalTo: topAnchor),
            
            lowerTextField.centerXAnchor.constraint(equalTo: centerXAnchor),
            lowerTextField.topAnchor.constraint(equalTo: upperTextField.bottomAnchor, constant: .defaultInset),
                      
            button.centerXAnchor.constraint(equalTo: centerXAnchor),
            button.topAnchor.constraint(equalTo: lowerTextField.bottomAnchor, constant: .defaultInset),
            button.bottomAnchor.constraint(equalTo: bottomAnchor),
            button.widthAnchor.constraint(equalToConstant: .defaultWidth),
            button.heightAnchor.constraint(equalToConstant: .defaultHeight)]
        
        NSLayoutConstraint.activate(constraints)
    }
}
