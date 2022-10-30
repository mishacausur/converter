//
//  MainViewAssembly.swift
//  Converter
//
//  Created by Misha Causur on 28.10.2022.
//

extension ModuleFactory {
    
    static func createMainModule(_ coordinator: Coordinatable, dataManager: DataManager) -> Module<MainViewController> {
        let viewModel = MainViewModel(dataManager: dataManager)
        viewModel.coordinator = coordinator
        let viewController = MainViewController(viewModel: viewModel)
        viewModel.mainView = viewController
        return Module(presentable: viewController)
    }
}
