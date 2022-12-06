//
//  MainViewRouter.swift
//  Converter
//
//  Created by Misha Causur on 25.11.2022.
//

import RxCocoa
import RxSwift
import class UIKit.UIViewController

struct MainViewRouter: RouterType {
    
    let vc: UIViewController
    
    init(transitionHandler: UIViewController) {
       vc = transitionHandler
    }
    
    func startCurrencyListFlow() -> Signal<Currency> {
        Single.create { observer in
            let module = ModuleFactory.createCurrencyListModule {
                observer(.success($0))
            }
            vc.navigationController?.pushViewController(module.presentable, animated: true)
            return Disposables.create()
        }
        .asSignal(onErrorSignalWith: .empty())
    }
}
