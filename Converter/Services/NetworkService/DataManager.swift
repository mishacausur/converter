//
//  DataManager.swift
//  Converter
//
//  Created by Misha Causur on 30.10.2022.
//

import Foundation

final class DataManager {
    @Published var firstCurrency: Currency?
    @Published var secondCurrency: Currency?
    var firstCurrencyValue: Int = 0
    var secondCurrencyValue: Int = 0
    var lastChangedField: CurrencyButton = .upper
    var openedFirstCurrency: Bool = true
}
