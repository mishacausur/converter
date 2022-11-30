//
//  DataManager.swift
//  Converter
//
//  Created by Misha Causur on 30.10.2022.
//

import RxCocoa

final class DataManager {
    
    /// Published properties
    var firstCurrency: Driver<Currency> {
        _firstCurrency.asDriver(onErrorJustReturn: .init(sign: "", name: ""))
    }
    
    var secondCurrency: Driver<Currency> {
        _secondCurrency.asDriver(onErrorJustReturn: .init(sign: "", name: ""))
    }
    
    var valueEntered: Driver<Bool> {
        _valueEntered.asDriver()
    }
    
    var dataToConvert: (to: String, from: String, amount: Int) {
        let from = lastChangedField == .upper ? firstCurrencySign : secondCurrencySign
        let to = lastChangedField == .upper ? secondCurrencySign : firstCurrencySign
        let amount = lastChangedField == .upper ? firstCurrencyValue : secondCurrencyValue
        return (to, from, amount)
    }
    
    private let _firstCurrency = PublishRelay<Currency>()
    private let _secondCurrency = PublishRelay<Currency>()
    private let _valueEntered = BehaviorRelay(value: false)
    private(set) var firstCurrencyValue: Int = 0
    private(set) var secondCurrencyValue: Int = 0
    private var firstCurrencySign = ""
    private var secondCurrencySign = ""
   
    func storeCurrency(_ currency: Currency, into: CurrencyButton) {
        switch into {
        case .upper:
            firstCurrencySign = currency.sign
            _firstCurrency.accept(currency)
        case .lower:
            secondCurrencySign = currency.sign
            _secondCurrency.accept(currency)
        }
    }
    
    func storeValue(store value: Int, into: CurrencyButton) {
        switch into {
        case .upper:
            firstCurrencyValue = value
            lastChangedField = .upper
        case .lower:
            secondCurrencyValue = value
            lastChangedField = .lower
        }
        checkValues()
    }
    /// Checking properties
    private (set) var lastChangedField: CurrencyButton = .upper

    var isFirstValueCorrect: Bool {
        firstCurrencyValue > 0
    }
    var isSecondValueCorrect: Bool {
        secondCurrencyValue > 0
    }

    /// Private properties
    private var hasRequiredValue: Bool {
        isFirstValueCorrect || isSecondValueCorrect
    }
    
    private func checkValues() {
        guard hasRequiredValue else { return }
        _valueEntered.accept(true)
    }
}
