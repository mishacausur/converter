//
//  ViewModelType.swift
//  Converter
//
//  Created by Misha Causur on 23.11.2022.
//

protocol ViewModelType {
    
    associatedtype Inputs = Void
    
    associatedtype Bindings = Void
   
    associatedtype Dependencies = Void
    
    associatedtype Routes: RouterType = EmptyRouter
    
    static func configure(
        input: Inputs,
        binding: Bindings,
        dependency: Dependencies,
        router: Routes
    ) -> Self
}
