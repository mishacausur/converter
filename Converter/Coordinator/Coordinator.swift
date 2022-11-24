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
        startMainFlow()
    }
    
    func route(_ destination: Route) {
        switch destination {
        case .currencyList:
            startCurrencyListFLow()
        case .currencyList_arch(let items, let cache, let manager):
            startCurrencyListFLow_Arch(items, cacheService: cache, dataManager: manager)
        case .dismiss:
            navigationController.popViewController(animated: true)
        }
    }
    
    private func startMainFlow() {
        let mainModule = ModuleFactory.createMainModule(self, locator: locator)
        navigationController.pushViewController(mainModule.presentable, animated: false)
    }
    
    private func startCurrencyListFLow() {
        let module = ModuleFactory.createCurrencyListModule(self, locator: locator)
        navigationController.pushViewController(module.presentable, animated: true)
    }
    
    private func startCurrencyListFLow_Arch(_ currencies: [Currency]?, cacheService: CacheService, dataManager: DataManager) {
        
        let builder = CurrencyListScreenBuilder()
        let vc = builder.build(.init(dataManager: dataManager, cache: cacheService, currencies: currencies) { [weak self] in
            self?.route(.dismiss)
        })
        navigationController.pushViewController(vc, animated: true)
    }
}
