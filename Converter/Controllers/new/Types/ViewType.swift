//
//  ViewType.swift
//  Converter
//
//  Created by Misha Causur on 23.11.2022.
//

protocol ViewType: HasEmptyInitialization {
    
    associatedtype ViewModel: ViewModelType
    
    /// Здесь передаем все состояния и события из контроллера в модель.
    var bindings: ViewModel.Bindings { get }
    
    /// Здесь происходит привязка состояний модели к экрану.
    func bind(to viewModel: ViewModel)
    
    static func make() -> Self
}

extension ViewType {
    
    static func make() -> Self {
        return Self.init()
    }
}
