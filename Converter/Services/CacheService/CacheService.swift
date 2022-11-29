//
//  CacheService.swift
//  Converter
//
//  Created by Misha Causur on 30.10.2022.
//

import RxCocoa

final class CacheService {
    
    static let shared = CacheService()
    
    var isEmpty: Bool {
        _storedCurrencies.value.isEmpty
    }
    
    var storedCurrencies: Driver<[Currency]> {
        _storedCurrencies.asDriver()
    }
    
    private let _storedCurrencies = BehaviorRelay<[Currency]>(value: [])
    
    func store(_ items: [Currency]) {
        _storedCurrencies.accept(items)
    }
}
