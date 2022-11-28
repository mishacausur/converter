//
//  CurrencyViewModel_Arch.swift
//  Converter
//
//  Created by Misha Causur on 23.11.2022.
//

import Foundation
import RxCocoa
import RxSwift

struct CurrencyViewModel_Arch {
    let currencies: Driver<[Currency]>
    let isLoading: Driver<Bool>
    let disposables: CompositeDisposable
}

extension CurrencyViewModel_Arch: ViewModelType {
   
    struct Inputs {
        let currencyDidChosen: ((Currency) -> Void)?
    }
    
    struct Bindings {
        let searchText: Driver<String>
        let didChosenCurrency: Signal<Currency>
    }
    
    struct Dependecies {
        let networkService: NetworkService
        var cacheService: CacheService
    }
    
    typealias Router = CurrencyRouter
    
    static func configure(input: Inputs, binding: Bindings, dependency: Dependecies, router: Router) -> CurrencyViewModel_Arch {
        let currencies = BehaviorRelay(value: [Currency]())
        let isLoading = BehaviorRelay(value: dependency.cacheService.isEmpty)
        let cachedCurrencies = dependency.cacheService.storedCurrencies
        
        let currencyNetworkDesposable = dependency.networkService
            .getCurrencies()
            .asSignal(onErrorJustReturn: [])
            .emit {
                let items = $0.sorted { $0.name < $1.name }
                dependency.cacheService.store(items)
                currencies.accept(items)
                isLoading.accept(false)
            }
        
        let currenciesFlatMapped = cachedCurrencies
            .flatMapLatest { cached -> Driver<[Currency]> in
                guard cached.isEmpty else {
                    _ = cachedCurrencies.drive(currencies)
                    return currencies.asDriver()
                }
                return currencies.asDriver()
            }
        
        let filteredCurrenciesDesposable = Driver.combineLatest(cachedCurrencies, binding.searchText) { cache, searchText in
            cache.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
            .drive(currencies)
        
        let choseCurrencyAndDismissDisposable = binding.didChosenCurrency.emit {
            input.currencyDidChosen?($0)
            router.dismiss()
        }
        
        let compositeDisposables = CompositeDisposable(filteredCurrenciesDesposable, choseCurrencyAndDismissDisposable, currencyNetworkDesposable)

        return .init(currencies: currenciesFlatMapped.asDriver(),
                     isLoading: isLoading.asDriver(),
                     disposables: compositeDisposables)
    }
}
