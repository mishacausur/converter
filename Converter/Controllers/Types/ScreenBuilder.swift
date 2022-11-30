//
//  ScreenBuilder.swift
//  Converter
//
//  Created by Misha Causur on 23.11.2022.
//

import class UIKit.UIViewController

protocol ScreenBuilder: HasEmptyInitialization {
    
    associatedtype VC: UIViewController & ViewType
   
    var dependencies: VC.ViewModel.Dependencies { get }
}

extension ScreenBuilder {
   
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
