//
//  CurrencyListScreenBuilder.swift
//  Converter
//
//  Created by Миша on 23.11.2022.
//


final class CurrencyListScreenBuilder: ScreenBuilder {
    var dependencies: CurrencyViewModel_Arch.Dependecies {
        .init(dataManager: .init(),
              networkService: .init())
    }
    
    typealias VC = CurrencyViewController_Arch
}

import class UIKit.UIViewController
struct CurrencyRouter: RouterType {
    
    let vc: CurrencyViewController_Arch
    
    init(transitionHandler: CurrencyViewController_Arch) {
        vc = transitionHandler
    }
    
}
