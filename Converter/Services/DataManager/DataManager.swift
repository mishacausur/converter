//
//  DataManager.swift
//  Converter
//
//  Created by Misha Causur on 30.10.2022.
//

import Foundation

final class DataManager {
    
    /// Published properties
    @Published var firstCurrency: Currency? {
        didSet {
            checkValues()
        }
    }
    @Published var secondCurrency: Currency? {
        didSet {
            checkValues()
        }
    }
    @Published var valueEntered = false
    
    /// Currencies values properties
    var firstCurrencyValue: Int = 0 {
        didSet {
            checkValues()
        }
    }
    var secondCurrencyValue: Int = 0 {
        didSet {
            checkValues()
        }
    }
    
    /// Checking properties
    var lastChangedField: CurrencyButton = .upper
    var openedFirstCurrency: Bool = true
    var isFirstValueCorrect: Bool {
        firstCurrencyValue > 0
    }
    var isSecondValueCorrect: Bool {
        secondCurrencyValue > 0
    }
    
    /// Private properties
    private var hasRequiredValue: Bool {
        !areCurrenciesEmpty && (isFirstValueCorrect || isSecondValueCorrect)
    }
    
    private var areCurrenciesEmpty: Bool {
        return firstCurrency == nil && secondCurrency == nil
    }

    private func checkValues() {
        guard hasRequiredValue else { return }
        valueEntered = true
    }
}
