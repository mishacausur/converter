//
//  CurrencyRouter.swift
//  Converter
//
//  Created by Misha Causur on 24.11.2022.
//

import class UIKit.UIViewController

struct CurrencyRouter: RouterType {
    
    let vc: CurrencyViewController_Arch
    
    init(transitionHandler: CurrencyViewController_Arch) {
        vc = transitionHandler
    }
}
