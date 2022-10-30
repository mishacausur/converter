//
//  String.swift
//  Converter
//
//  Created by Misha Causur on 28.10.2022.
//

extension String {
    // MARK: - UI
    static let convert = "Convert"
    static let enterValue = "Enter value"
    static let chooseCurrency = "Choose"
    static let currencies = "Currencies"
    static let mainViewTitle = "Converter"
    static let ok = "OK"
    
    // MARK: - Services
    static let empty = ""
    static let cellID = "Cell"
    
    // MARK: - Errors
    /// Empty currencies
    static let emptyCurrencyTitle = "You haven't chose any currency"
    static let emptyCurrencyDescription = "Please, chose both of the currencies to allow exchange 'em"
    /// Same values
    static let sameValuesTitle = "You've chosen the same values of currencies"
    static let sameValuesDescription = "Exchange currency into itself doesn't have any meaning"
    /// Empty Values
    static let emptyValuesTitle = "You need to enter the value"
    static let emptyValuesDescription = "Enter a number of currency you want to exchange"
    /// Error undefined
    static let errorTitle = "Error has occured"
    static let errorDescription = "Something goes wrong but we're already working to fix it"
}
