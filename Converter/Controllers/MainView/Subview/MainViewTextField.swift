//
//  MainViewTextField.swift
//  Converter
//
//  Created by Misha Causur on 29.10.2022.
//

import RxCocoa

final class MainViewTextField: Viеw {
    
    private lazy var ui = createUI()
    
    var didTapButton: Signal<Void> {
        ui.button.rx
            .tap
            .asSignal()
    }
    
    var didEnterTextFieldValue: Signal<String> {
        ui.textField.rx
            .text
            .compactMap { $0 }
            .asSignal(onErrorJustReturn: .empty)
    }
    
    var value: String {
        get {
            ui.textField.text ?? .empty
        }
        set {
            ui.textField.text = newValue
        }
    }
    
    override func configure() {
        layoutView()
    }
    
    func configureLabel(currency: String) {
        ui.circle.configureLabel(currency)
    }
}

private extension MainViewTextField {
    
    struct UI {
        let textField: TextField
        let circle: CircleLabel
        let button: Button
    }
    
    func createUI() -> UI {
        let textField = UIFactory
            .createTextField(with: .enterValue)
        
        let circle = CircleLabel()
        
        let textFieldButton = UIFactory
            .createButton(
                with: .chooseCurrency,
                radius: .smallCornerRadius,
                font: .small
            )
        
        addViews(
            textField,
            circle,
            textFieldButton
        )
        
        return .init(
            textField: textField,
            circle: circle,
            button: textFieldButton
        )
    }
    
    func layoutView() {
        
        ui.textField.pin
            .top()
            .bottom()
            .left()
            .width(.defaultWidth - .defaultWidth/3 + .smallInset)
            .height(.defaultHeight)
        
        ui.circle.pin
            .left(of: ui.textField, aligned: .center)
        
        ui.button.pin
            .left(to: ui.textField.edge.right)
            .marginLeft(-.smallInset)
            .right()
            .width(.defaultWidth/3)
            .height(.defaultHeight)
    }
}
