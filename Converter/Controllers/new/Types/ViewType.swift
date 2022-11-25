//
//  ViewType.swift
//  Converter
//
//  Created by Misha Causur on 23.11.2022.
//

protocol ViewType: HasEmptyInitialization {
    
    associatedtype ViewModel: ViewModelType
   
    var bindings: ViewModel.Bindings { get }
    
    func bind(to viewModel: ViewModel)
    
    static func make() -> Self
}

extension ViewType {
    
    static func make() -> Self {
        return Self.init()
    }
}
