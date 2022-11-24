//
//  CacheService.swift
//  Converter
//
//  Created by Misha Causur on 30.10.2022.
//

import Foundation

final class CacheService {
    
    static let shared = CacheService()
    
    private(set) var storedCurrencies: [Currency] = []
    
    var isEmpty: Bool {
        storedCurrencies.isEmpty
    }
    
    func store(_ items: [Currency]) {
        storedCurrencies = items
    }
}
