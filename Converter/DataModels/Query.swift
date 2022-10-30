//
//  Query.swift
//  Converter
//
//  Created by Misha Causur on 29.10.2022.
//

import Foundation

struct Query: Codable {
    let amount: Int
    let from, to: String
}
