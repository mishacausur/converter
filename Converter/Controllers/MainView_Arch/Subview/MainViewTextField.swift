//
//  MainViewTextField.swift
//  Converter
//
//  Created by Misha Causur on 29.10.2022.
//

import RxCocoa

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
            .asSignal(onErrorJustReturn: .empty)
    }
    
    var value: String {
        get {
            textField.text ?? ""
        }
        set {
            textField.text = newValue
        }
    }
    private let textField = UIFactory
        .createTextField(with: .enterValue)
    
    private let circle = CircleLabel()
    
    private let textFieldButton = UIFactory
        .createButton(
            with: .chooseCurrency,
            radius: .smallCornerRadius,
            font: .small
        )
    
    override func addViews() {
        addViews(
            textField,
            circle,
            textFieldButton
        )
    }
    
    override func layout() {
        
        textField.pin
            .top()
            .bottom()
            .left()
            .width(.defaultWidth - .defaultWidth/3 + .smallInset)
            .height(.defaultHeight)
        
        circle.pin
            .left(of: textField, aligned: .center)
        
        textFieldButton.pin
            .left(to: textField.edge.right)
            .marginLeft(-.smallInset)
            .right()
            .width(.defaultWidth/3)
            .height(.defaultHeight)
        
        pin
            .height(.defaultHeight)
            .width(textField.frame.width + textFieldButton.frame.width)
    }
    
    func configureLabel(currency: String) {
        circle.configureLabel(currency)
    }
}
