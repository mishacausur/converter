//
//  Error.swift
//  Converter
//
//  Created by Misha Causur on 30.10.2022.
//

import Foundation

// MARK: - Network errors

enum NetworkError: Error {
    case badURL
    case badData
    case badDecode
}

enum AppError: Error {
    case emptyCurrencies
    case sameItems
    case sameValues
    case undefined
    
    static func error(_ error: AppError) -> (String, String) {
        switch error {
       
        case .emptyCurrencies:
            return (.sameValuesTitle, .sameValuesDescription)
        case .sameItems:
            return (.emptyCurrencyTitle, .emptyCurrencyDescription)
        case .sameValues:
            return (.sameValuesTitle, .sameValuesDescription)
        case .undefined:
            return (.errorTitle, .errorDescription)
        }
    }
}
