//
//  CurrencyListAssembly.swift
//  Converter
//
//  Created by Misha Causur on 29.10.2022.
//

extension ModuleFactory {
    
    static func createCurrencyListModule(_ currencyDidChosen: @escaping (Currency) -> Void) -> Module<CurrencyViewController> {
        
        let builder = CurrencyListScreenBuilder()
        let vc = builder.build(.init(currencyDidChosen: currencyDidChosen))
        return Module(presentable: vc)
    }
}
