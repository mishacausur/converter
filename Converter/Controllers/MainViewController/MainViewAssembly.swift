//
//  MainViewAssembly.swift
//  Converter
//
//  Created by Misha Causur on 28.10.2022.
//
import UIKit

extension ModuleFactory {
    
    static func createMainModule(_ coordinator: Coordinatable) -> Module<MainViewController> {
        let viewModel = MainViewModel()
        viewModel.coordinator = coordinator
        let viewController = MainViewController(viewModel: viewModel)
        return Module(presentable: viewController)
    }
}
