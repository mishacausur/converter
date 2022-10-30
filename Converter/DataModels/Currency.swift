//
//  Currency.swift
//  Converter
//
//  Created by Misha Causur on 29.10.2022.
//

import Foundation

struct Convert: Codable {
    let query: Query
    let result: Double
    let success: Bool
}
