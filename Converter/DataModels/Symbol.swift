//
//  Symbol.swift
//  Converter
//
//  Created by Misha Causur on 30.10.2022.
//

import Foundation

struct Symbol: Decodable {
    let success: Bool
    let symbols: [String: String]
    
    private enum CodingKeys: String, CodingKey {
        case success
        case symbols
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        success = try container.decode(Bool.self, forKey: .success)
        symbols = try container.decode([String: String].self, forKey: .symbols)
    }
}

struct Currency {
    let sign: String
    let name: String
}

extension Currency: Equatable {

}
