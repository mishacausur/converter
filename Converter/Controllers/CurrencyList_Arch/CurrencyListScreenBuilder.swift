//
//  CurrencyListScreenBuilder.swift
//  Converter
//
//  Created by Misha Causur on 23.11.2022.
//


final class CurrencyListScreenBuilder: ScreenBuilder {
    var dependencies: CurrencyViewModel.Dependecies {
        .init(networkService: .init(),
              cacheService: CacheService.shared)
    }
    
    typealias VC = CurrencyViewController
}
