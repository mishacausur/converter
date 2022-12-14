//
//  MainViewModel_Arch.swift
//  Converter
//
//  Created by Misha Causur on 25.11.2022.
//

import RxCocoa
import RxSwift

struct MainViewModel {
    let upperCurrency: Driver<String>
    let lowerCurrency: Driver<String>
    let upperFieldValue: Driver<String>
    let lowerFieldValue: Driver<String>
    let isConvertButtonHidden: Driver<Bool>
    let isLoading: Driver<Bool>
    let disposables: Disposable
}

extension MainViewModel: ViewModelType {
    
    typealias Inputs = Void
    
    struct Bindings {
        let didTapButton: Signal<CurrencyButton>
        let didEnterFieldValue: Signal<(CurrencyButton, String)>
        let didTapConvertButton: Signal<Void>
    }
    
    struct Dependencies {
        let networkService: NetworkService
    }
    
    typealias Router = MainViewRouter
    
    static func configure(input: Inputs, binding: Bindings, dependency: Dependencies, router: Router) -> MainViewModel {
        let upperValue = BehaviorRelay<String>(value: .empty)
        let lowerValue = BehaviorRelay<String>(value: .empty)
        let isLoading = BehaviorRelay<Bool>(value: false)
        
        // MARK: - CURRENCIES
        /// opens `currency list controller` and gets back the chosen one
        /// first currency
        let upperCurrency = binding
            .didTapButton
            .filter { $0 == .upper }
            .flatMapLatest { _ in
                router.startCurrencyListFlow()
            }
            .map(Optional.init)
            .startWith(nil)
            .asDriver(onErrorDriveWith: .empty())
        
        /// second currency
        let lowerCurrency = binding
            .didTapButton
            .filter { $0 == .lower }
            .flatMapLatest { _ in
                router.startCurrencyListFlow()
            }
            .map(Optional.init)
            .startWith(nil)
            .asDriver(onErrorDriveWith: .empty())
        
        // MARK: - TEXTFIELD
        
        /// checking value
        let filter: (String) -> (Bool) = {
            Int($0) ?? 0 > 0
        }
        
        /// setup value to the text field due to user has entered it
        let didEnteredValueDisposable = binding
            .didEnterFieldValue
            .filter { filter($0.1) }
            .emit { button, value in
                switch button {
                case .upper:
                    upperValue.accept(value)
                case .lower:
                    lowerValue.accept(value)
                }
            }
        
        // MARK: - The last text field was active
        /// (to figure out `to` and `from` variables)
        let lastResponder = binding
            .didEnterFieldValue
            .filter { !$0.1.isEmpty }
            .map(\.0)
            .distinctUntilChanged()
            .asDriver(onErrorDriveWith: .empty())
        
        let didEnteredNonEmptyValue = Driver
            .combineLatest(
                upperValue.asDriver(),
                lowerValue.asDriver()
            )
            .asObservable()
            .map { !$0.0.isEmpty || !$0.1.isEmpty }
            .asDriver(onErrorDriveWith: .empty())
        
        // MARK: - Convert button visiability
        /// should be hidden if there ain't value and chosen currencies on the screen
        let isButtonHidden: Driver<Bool> = Driver
            .combineLatest(
                didEnteredNonEmptyValue,
                upperCurrency
                    .asDriver(),
                lowerCurrency
                    .asDriver()
            ) { hasValue, upperCurrency, lowerCurrency -> Bool in
                return upperCurrency != nil && lowerCurrency != nil && hasValue
            }
        
        // MARK: - ALL OF THE VARIABLES
        let values = Driver.combineLatest(
            /// 1). last text field changed
            lastResponder,
            /// 2). value from the first text field
            upperValue
                .asDriver()
                .distinctUntilChanged(),
            /// 3). value from the second text field
            lowerValue
                .asDriver()
                .distinctUntilChanged(),
            /// 4). the first currency sign as a `String`
            upperCurrency
                .compactMap { $0 }
                .map(\.sign),
            /// 5). the second currency sign as a `String`
            lowerCurrency
                .compactMap { $0 }
                .map(\.sign)
        )
        
        
        // MARK: - CONVERTING VIA NETWORKSERVICE
        let convertValues = binding
            .didTapConvertButton
            .withLatestFrom(values)
        /// unite subscribtions needed
            .flatMapLatest { button, upperValue, lowerValue, upperCurrency, lowerCurrency in
                /// 1). the `to` currency
                let to = button == .lower ? lowerCurrency : upperCurrency
                /// 2). the `from` currency
                let from = button == .upper ? lowerCurrency : upperCurrency
                /// 3). the `amount` from last responder (the last text field that had been changed)
                let amount = Int(button == .upper ? upperValue : lowerValue) ?? 0
                
                return dependency
                    .networkService
                    .convertCurrencies(
                        to: from,
                        from: to,
                        amount: amount
                    )
                /// notificate the driver for activity loading has started
                .do(onSubscribe: {
                        isLoading.accept(true)
                /// notificate the driver for activity loding is finished
                    }, onDispose: {
                        isLoading.accept(false)
                    })
                /// getting the very one value ( result as a `Double`)
                .map(\.result)
                /// just to make it work
                .asDriver(onErrorDriveWith: .empty())
                    .debug()
            }
        
        let didGetConvertResponseDisposable = convertValues
            .compactMap { String(describing: $0) }
            .withLatestFrom(lastResponder) { ($0, $1) }
            .asSignal(onErrorSignalWith: .empty())
            .emit {
                switch $1 {
                case .upper:
                    lowerValue.accept($0)
                case .lower:
                    upperValue.accept($0)
                }
            }
        
        let disposables = CompositeDisposable(
            didGetConvertResponseDisposable,
            didEnteredValueDisposable
        )
        
        return .init(
            upperCurrency: upperCurrency.compactMap(\.?.sign),
            lowerCurrency: lowerCurrency.compactMap(\.?.sign),
            upperFieldValue: upperValue.asDriver(),
            lowerFieldValue: lowerValue.asDriver(),
            isConvertButtonHidden: isButtonHidden,
            isLoading: isLoading.asDriver(),
            disposables: disposables
        )
    }
}
