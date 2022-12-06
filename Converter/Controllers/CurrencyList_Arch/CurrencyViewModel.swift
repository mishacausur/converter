//
//  CurrencyViewModel.swift
//  Converter
//
//  Created by Misha Causur on 23.11.2022.
//

import Foundation
import RxCocoa
import RxSwift

struct CurrencyViewModel {
    let currencies: Driver<[Currency]>
    let isLoading: Driver<Bool>
    let disposables: Disposable
}

extension CurrencyViewModel: ViewModelType {
   
    struct Inputs {
        let currencyDidChosen: (Currency) -> Void
    }
    
    struct Bindings {
        let searchText: Driver<String>
        let didSelectModel: Signal<Currency>
    }
    
    struct Dependecies {
        let networkService: NetworkService
        var cacheService: CacheService
    }
    
    typealias Router = CurrencyRouter
    
    static func configure(input: Inputs, binding: Bindings, dependency: Dependecies, router: Router) -> CurrencyViewModel {
       
        let currencyNetwork = dependency
            .networkService
            .getCurrencies()
            .asObservable()
            .map { $0.sorted { $0.name < $1.name } }
            .do(onNext: dependency.cacheService.store)
                
        let isLoading = currencyNetwork
            .map { _ in false }
            .startWith(dependency.cacheService.isEmpty)
            .asDriver(onErrorJustReturn: true)
        
        let сurrencies = dependency
            .cacheService
            .storedCurrencies
            .flatMapLatest { currencies -> Driver<[Currency]> in
                guard currencies.isEmpty else {
                    return .just(currencies)
                }
                return currencyNetwork
                    .asDriver(onErrorJustReturn: [])
            }
        
        let filteredCurrencies = Driver
            .combineLatest(
                сurrencies,
                binding.searchText
            ) { cache, searchText in
                guard !searchText.isEmpty else { return cache }
                return cache.filter {
                    $0.name.lowercased().contains(searchText.lowercased())
                }
            }
        
        let choseCurrencyAndDismissDisposable = binding
            .didSelectModel
            .emit {
                input.currencyDidChosen($0)
                router.dismiss()
            }
        
        return .init(
            currencies: filteredCurrencies,
            isLoading: isLoading.asDriver(),
            disposables: choseCurrencyAndDismissDisposable
        )
    }
}
