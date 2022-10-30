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
    
    let dataManager = DataManager()
    
    init(_ window: UIWindow) {
        self.window = window
        navigationController = .init()
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
    
    func start() {
        startMainFlow()
    }
    
    func route(_ destination: Route) {
        switch destination {
        case .currencyList:
            startCurrencyListFLow()
        case .dismiss:
            navigationController.popViewController(animated: true)
        }
    }
    
    private func startMainFlow() {
        let mainModule = ModuleFactory.createMainModule(self, dataManager: dataManager)
        navigationController.pushViewController(mainModule.presentable, animated: false)
    }
    
    private func startCurrencyListFLow() {
        let module = ModuleFactory.createCurrencyListModule(self, dataManager: dataManager)
        navigationController.pushViewController(module.presentable, animated: true)
    }
}
