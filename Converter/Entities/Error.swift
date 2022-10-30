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

// MARK: - Application error (UI showing)

enum AppError: Error {
    case emptyCurrencies
    case emptyValues
    case sameValues
    case undefined
    
    static func error(_ error: AppError) -> (String, String) {
        switch error {
       
        case .emptyCurrencies:
            return (.emptyCurrencyTitle, .emptyCurrencyDescription)
        case .emptyValues:
            return (.emptyValuesTitle, .emptyValuesDescription)
        case .sameValues:
            return (.sameValuesTitle, .sameValuesDescription)
        case .undefined:
            return (.errorTitle, .errorDescription)
        }
    }
}
