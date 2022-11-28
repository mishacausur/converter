//
//  MainViewAssembly.swift
//  Converter
//
//  Created by Misha Causur on 28.10.2022.
//

extension ModuleFactory {
    
    static func createMainModule(_ coordinator: Coordinatable, locator: Locator) -> Module<MainViewController> {
        
        let viewModel = MainViewModel(locator: locator)
        viewModel.coordinator = coordinator
        let viewController = MainViewController(viewModel: viewModel)
        viewModel.mainView = viewController
        return Module(presentable: viewController)
    }
    
    static func createMainModule_Arch() -> Module<MainViewController_Arch> {
        
        let builder = MainViewScreenBuilder()
        let vc = builder.build(())
       
        return Module(presentable: vc)
    }
    
}
