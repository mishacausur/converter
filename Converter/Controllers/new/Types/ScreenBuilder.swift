//
//  ScreenBuilder.swift
//  Converter
//
//  Created by Миша on 23.11.2022.
//

import class UIKit.UIViewController

protocol ScreenBuilder: HasEmptyInitialization {
    
    associatedtype VC: UIViewController & ViewType
    
    /// Здесь передаем все зависимости экрана.
    var dependencies: VC.ViewModel.Dependencies { get }
}

extension ScreenBuilder {
    
    /// Здесь создается контроллер, модель и роутер, и связываются друг с другом.
    func build(
        _ inputs: VC.ViewModel.Inputs
    ) -> VC where VC.ViewModel.Routes.TransitionHandler == UIViewController {
        
        let vc = VC.make()
        vc.loadViewIfNeeded()
        
        let vm = VC.ViewModel.configure(
            input: inputs,
            binding: vc.bindings,
            dependency: dependencies,
            router: VC.ViewModel.Routes(transitionHandler: vc)
        )
        
        vc.bind(to: vm)
        
        return vc
    }
}
