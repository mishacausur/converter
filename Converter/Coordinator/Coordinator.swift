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
    
    init(_ window: UIWindow) {
        self.window = window
        navigationController = .init()
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
    
    func start() {
        let viewModel = MainViewModel()
        viewModel.coordinator = self
        let controller = MainViewController(viewModel: viewModel)
        navigationController.pushViewController(controller, animated: false)
    }
    
    func route(_ destination: Route) {
        switch destination {
        case .smth:
            print("some occured")
        case .dismiss:
            navigationController.dismiss(animated: true)
        }
    }
}
