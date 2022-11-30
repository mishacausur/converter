//
//  MainViewModel_Arch.swift
//  Converter
//
//  Created by Misha Causur on 25.11.2022.
//

import RxCocoa
import RxSwift

struct MainViewModel_Arch {
    let firstCurrency: Driver<Currency>
    let secondCurrency: Driver<Currency>
    let valueEntered: Driver<Bool>
    let convertedValue: Driver<(Convert, CurrencyButton)>
    let disposables: Disposable
}

extension MainViewModel_Arch: ViewModelType {
    
    typealias Inputs = Void
    
    struct Bindings {
        let didTapButton: Signal<CurrencyButton>
        let didEnterFieldValue: Signal<(CurrencyButton, String)>
        let didTapConvertButton: Signal<Void>
    }
    
    struct Dependecies {
        let networkService: NetworkService
        let dataManager: DataManager
    }
    
    typealias Router = MainViewRouter
    
    static func configure(input: Inputs, binding: Bindings, dependency: Dependecies, router: Router) -> MainViewModel_Arch {
        
        var fieldToChange: CurrencyButton = .lower
        
        let didTappedConvert = binding
            .didTapConvertButton
            .asSignal()
            .flatMapLatest { () -> Driver<(Convert, CurrencyButton)> in
                return dependency.networkService
                    .convertCurrencies(
                    to: dependency.dataManager.dataToConvert.to,
                    from: dependency.dataManager.dataToConvert.from,
                    amount: dependency.dataManager.dataToConvert.amount)
                .map { ($0, fieldToChange) }
                .asDriver(onErrorJustReturn: (.init(result: 0.0, success: false), .upper))
            }
        
        let fieldValueEnteredDisposable = binding
            .didEnterFieldValue
            .emit(onNext: {
                guard let number = Int($0.1) else { return }
                dependency.dataManager.storeValue(store: number, into: $0.0)
                fieldToChange = $0.0 == .upper ? .lower : .upper
            })
        
        let didButtonTappedDisposable = binding
            .didTapButton
            .emit {
                let field = $0
                router.startCurrencyListFlow {
                    dependency
                        .dataManager
                        .storeCurrency($0, into: field)
                }
            }
        
        let disposables = CompositeDisposable(
            fieldValueEnteredDisposable,
            didButtonTappedDisposable
        )
        
        return .init(
            firstCurrency: dependency.dataManager.firstCurrency,
            secondCurrency: dependency.dataManager.secondCurrency,
            valueEntered: dependency.dataManager.valueEntered,
            convertedValue: didTappedConvert,
            disposables: disposables
        )
    }
}
