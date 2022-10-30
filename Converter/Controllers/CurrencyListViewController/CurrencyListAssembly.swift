//
//  CurrencyListAssembly.swift
//  Converter
//
//  Created by Misha Causur on 29.10.2022.
//

extension ModuleFactory {
    
    static func createCurrencyListModule(_ coordinator: Coordinatable, dataManager: DataManager) -> Module<CurrencyListViewController> {
        let viewModel = CurrencyViewModel(dataManager: dataManager)
        viewModel.coordinator = coordinator
        let viewController = CurrencyListViewController(viewModel: viewModel)
        viewModel.currencyView = viewController
        return Module(presentable: viewController)
    }
}
