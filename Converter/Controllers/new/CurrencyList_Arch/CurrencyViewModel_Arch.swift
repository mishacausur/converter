//
//  CurrencyViewModel_Arch.swift
//  Converter
//
//  Created by Misha Causur on 23.11.2022.
//
import Foundation
import Combine

struct CurrencyViewModel_Arch {
    let publishedCurrencies: AnyPublisher<[Currency], NetworkError>
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
    
    class Bindings {
        var searchText: ((String) -> Void)? = nil
        var currencyDidChosen: ((Currency) -> Void)? = nil
    }
    
    struct Dependecies {
        let networkService: NetworkService
    }
    
    static func configure(input: Inputs, binding: Bindings, dependency: Dependecies, router: EmptyRouter) -> CurrencyViewModel_Arch {
        let subject = CurrentValueSubject<[Currency], NetworkError>([])
        let isFiltered = CurrentValueSubject<Bool, Never>(false)

        binding.searchText = { text in
            isFiltered.value = !text.isEmpty
            let items = input.cache.storedCurrencies.filter { $0.name.lowercased().contains(text.lowercased()) }
            subject.value = isFiltered.value ? items : input.cache.storedCurrencies
        }
        
        binding.currencyDidChosen = {
            switch input.dataManager.openedFirstCurrency {
            case true:
                input.dataManager.firstCurrency = $0
            case false:
                input.dataManager.secondCurrency = $0
            }
            input.dismiss()
        }
        
        return .init(publishedCurrencies: bindCurrencies(subject, networker: dependency.networkService, cache: input.cache))
    }
    
    static func bindCurrencies(_ subject: CurrentValueSubject<[Currency], NetworkError>, networker: NetworkService, cache: CacheService) -> AnyPublisher<[Currency], NetworkError> {
        switch cache.isEmpty {
        case true:
            networker.getCurrencies {
                switch $0 {
                case .success(let items):
                    let currencies = items.sorted { $0.name < $1.name }
                    cache.store(currencies)
                    subject.send(currencies)
                case .failure(let error):
                    subject.send(completion: .failure(error))
                }
            }
        case false:
            subject.send(cache.storedCurrencies)
        }
        return subject.eraseToAnyPublisher()
    }
}
