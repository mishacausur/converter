//
//  MainViewRouter.swift
//  Converter
//
//  Created by Misha Causur on 25.11.2022.
//

import class UIKit.UIViewController

struct MainViewRouter: RouterType {
    
    let vc: UIViewController
    
    init(transitionHandler: UIViewController) {
       vc = transitionHandler
    }
    
    func startCurrencyListFlow(_ currencyDidChosen: @escaping (Currency) -> Void) {
        let module = ModuleFactory.createCurrencyListModule(currencyDidChosen)
        vc.navigationController?.pushViewController(module.presentable, animated: true)
    }
}
