//
//  CurrencyViewModel_Arch.swift
//  Converter
//
//  Created by Misha Causur on 23.11.2022.
//
import Foundation
import Combine

struct CurrencyViewModel_Arch {
    let publishedCurrencies: AnyPublisher<[Currency], NetworkError>?
    let currencies: [Currency]?
}

extension CurrencyViewModel_Arch: ViewModelType {
    
    /// При наличии в кеше будут переданы сюда, в противном случае нужен сетевой запрос
    struct Inputs {
        let currencies: [Currency]?
        
        var isEmpty: Bool {
            guard let currencies = currencies else {
                return true
            }
            return currencies.isEmpty
        }
    }
    
    struct Bindings {
        var setupCurrencies: (Currency) -> Void = { _ in }
    }
    
    struct Dependecies {
        let dataManager: DataManager
        let networkService: NetworkService
    }
    
    static func configure(input: Inputs, binding: Bindings, dependency: Dependecies, router: EmptyRouter) -> CurrencyViewModel_Arch {
        return input.isEmpty
            ? .init(publishedCurrencies: bindCurrencies(dependency.networkService), currencies: nil)
            : .init(publishedCurrencies: nil, currencies: input.currencies)
    }
    
    static func bindCurrencies(_ networker: NetworkService) -> AnyPublisher<[Currency], NetworkError> {
        let subject = PassthroughSubject<[Currency], NetworkError>()
        networker.getCurrencies {
            switch $0 {
            case .success(let items):
                subject.send(items)
                subject.send(completion: .finished)
            case .failure(let error):
                subject.send(completion: .failure(error))
            }
        }
        return subject.eraseToAnyPublisher()
    }
    
}
