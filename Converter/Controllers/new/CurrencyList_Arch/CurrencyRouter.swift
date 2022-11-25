//
//  CurrencyRouter.swift
//  Converter
//
//  Created by Misha Causur on 24.11.2022.
//

import class UIKit.UIViewController

struct CurrencyRouter: RouterType {
    
    let vc: UIViewController
    
    init(transitionHandler: UIViewController) {
       vc = transitionHandler
    }
    
    func dismiss() {
        vc.navigationController?.popViewController(animated: true)
    }
}
