//
//  Coordinator.swift
//  Converter
//
//  Created by Misha Causur on 28.10.2022.
//

import UIKit.UINavigationController

final class Coordinator: Coordinatable {
    
    unowned let window: UIWindow
    var navigationController: UINavigationController
    
    let locator = Locator()
    
    init(_ window: UIWindow) {
        self.window = window
        navigationController = .init()
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
    
    func start() {
//        startMainFlow()
        startMainFlow_Arch()
    }
    
    func route(_ destination: Route) {
        switch destination {
        case .currencyList(let currencyDidChosen):
            startCurrencyListFlow(currencyDidChosen)
        case .dismiss:
            navigationController.popViewController(animated: true)
        }
    }
    
    private func startMainFlow_Arch() {
        let mainModule = ModuleFactory.createMainModule_Arch()
        navigationController.pushViewController(mainModule.presentable, animated: false)
    }
    
    private func startCurrencyListFlow(_ currencyDidChosen: @escaping (Currency) -> Void) {
        let module = ModuleFactory.createCurrencyListModule(currencyDidChosen)
        navigationController.pushViewController(module.presentable, animated: true)
    }
}
