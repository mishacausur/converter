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
    var storeCache: (([Currency]) -> Void)?
    var setupCurrency: ((Currency) -> Void)?
}

extension CurrencyViewModel_Arch: ViewModelType {
    
    struct Inputs {
        
        let dataManager: DataManager
        let cache: CacheService
        var currencies: [Currency] {
            cache.storedCurrencies
        }
        
        var isEmpty: Bool {
            cache.isEmpty
        }
        let dismiss: () -> Void
    }
    
    typealias Bindings = Void
    
    struct Dependecies {
        let networkService: NetworkService
    }
    
    static func configure(input: Inputs, binding: Bindings, dependency: Dependecies, router: EmptyRouter) -> CurrencyViewModel_Arch {
        var vm: CurrencyViewModel_Arch = input.isEmpty
            ? .init(publishedCurrencies: bindCurrencies(dependency.networkService), currencies: nil)
            : .init(publishedCurrencies: nil, currencies: input.currencies)
        
        vm.storeCache = {
            input.cache.store($0)
        }
        
        vm.setupCurrency = {
            switch input.dataManager.openedFirstCurrency {
            case true:
                input.dataManager.firstCurrency = $0
            case false:
                input.dataManager.secondCurrency = $0
            }
            input.dismiss()
        }
        
        return vm
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
