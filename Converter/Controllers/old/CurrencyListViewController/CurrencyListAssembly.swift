//
//  CurrencyListAssembly.swift
//  Converter
//
//  Created by Misha Causur on 29.10.2022.
//

extension ModuleFactory {
    
    static func createCurrencyListModule(_ coordinator: Coordinatable, locator: Locator) -> Module<CurrencyListViewController> {
        
        let viewModel = CurrencyViewModel(locator: locator)
        viewModel.coordinator = coordinator
        let viewController = CurrencyListViewController(viewModel: viewModel)
        viewModel.currencyView = viewController
        return Module(presentable: viewController)
    }
    
    static func createCurrencyListModule_Arch(_ currencyDidChosen: ((Currency) -> Void)?) -> Module<CurrencyViewController_Arch> {
        
        let builder = CurrencyListScreenBuilder()
        let vc = builder.build(.init(currencyDidChosen: currencyDidChosen))
        return Module(presentable: vc)
    }
}
