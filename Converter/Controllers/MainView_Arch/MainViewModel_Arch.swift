//
//  MainViewModel_Arch.swift
//  Converter
//
//  Created by Misha Causur on 25.11.2022.
//

import RxCocoa
import RxSwift

struct MainViewModel_Arch {
    let upperCurrency: Driver<Currency?>
    let lowerCurrency: Driver<Currency?>
    let upperFieldValue: Driver<String>
    let lowerFieldValue: Driver<String>
    let isConvertButtonHidden: Driver<Bool>
    let isLoading: Driver<Bool>
    let disposables: Disposable
}

extension MainViewModel_Arch: ViewModelType {
    
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
    
    static func configure(input: Inputs, binding: Bindings, dependency: Dependencies, router: Router) -> MainViewModel_Arch {
        
        let upperValue = BehaviorRelay<String>(value: "")
        let lowerValue = BehaviorRelay<String>(value: "")
        let isLoading = BehaviorRelay<Bool>(value: false)
        
        // MARK: - CURRENCIES
        /// opens `currency list controller` and gets back the chosen one
        /// first currency
        let upperCurrency = binding
            .didTapButton
            .filter { $0 == .upper }
            .flatMapFirst { _ in
                router.startCurrencyListFlow()
            }
            .map(Optional.init)
            .startWith(nil)
            .asDriver(onErrorDriveWith: .empty())
        
        /// first currency
        let lowerCurrency = binding
            .didTapButton
            .filter { $0 == .lower }
            .flatMapFirst { _ in
                router.startCurrencyListFlow()
            }
            .map(Optional.init)
            .startWith(nil)
            .asDriver(onErrorDriveWith: .empty())
        
        // MARK: - TEXTFIELD
        /// setup value to the text field due to user has entered it
        let didEnteredValueDisposable = binding
            .didEnterFieldValue
            .filter { Int($0.1) ?? 0 > 0 }
            .emit {
                switch $0.0 {
                case .upper:
                    upperValue.accept($0.1)
                case .lower:
                    lowerValue.accept($0.1)
                }
            }
        
        // MARK: - The last text field was active
        /// (to figure out `to` and `from` variables)
        let lastResponder = binding
            .didEnterFieldValue
//            .distinctUntilChanged(\.1)
            .map(\.0)
        
        // MARK: - Convert button visiability
        /// should be hidden if there ain't value and chosen currencies on the screen
        let isButtonHidden = Driver.combineLatest(
            lastResponder.asDriver(onErrorDriveWith: .empty()),
            upperCurrency.asDriver(),
            lowerCurrency.asDriver())
            .flatMapLatest {
                let value: BehaviorRelay<Bool> = .init(value: $0.1 != nil && $0.2 != nil)
                return value.asDriver()
            }
        
        // MARK: - ALL OF THE VARIABLES
        let values = Driver.combineLatest(
            /// 1). the last changed text field
            lastResponder
                .asDriver(onErrorDriveWith: .empty()),
            /// 2). value from the first text field
            upperValue.asDriver()
                .distinctUntilChanged(),
            /// 3). value from the second text field
            lowerValue.asDriver()
                .distinctUntilChanged(),
            /// 4). the first currency sign as a `String`
            upperCurrency.compactMap { $0 }.map(\.sign),
            /// 5). the second currency sign as a `String`
            lowerCurrency.compactMap { $0 }.map(\.sign)
        )
        
        
        // MARK: - CONVERTING VIA NETWORKSERVICE
        let convertValues = binding
            .didTapConvertButton
            .withLatestFrom(values)
        /// unite subscribtions needed
            .flatMapLatest {
                /// 1). the `to` currency
                let to = $0.0 == .lower ? $0.4 : $0.3
                /// 2). the `from` currency
                let from = $0.0 == .upper ? $0.4 : $0.3
                /// 3). the `amount` from last responder (the last text field that has been changed)
                let amount = $0.0 == .upper ? $0.1 : $0.2
                
                return dependency
                    .networkService
                    .convertCurrencies(
                        to: from,
                        from: to,
                        amount: Int(amount) ?? 0
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
            }
        
        let didGetConvertResponseDisposable = Signal.combineLatest(
            convertValues
                .compactMap { String(describing: $0) }
                .asSignal(onErrorSignalWith: .empty()),
            lastResponder
                .asSignal(onErrorSignalWith: .empty())
        )
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
            upperCurrency: upperCurrency,
            lowerCurrency: lowerCurrency,
            upperFieldValue: upperValue.asDriver(),
            lowerFieldValue: lowerValue.asDriver(),
            isConvertButtonHidden: isButtonHidden,
            isLoading: isLoading.asDriver(),
            disposables: disposables
        )
    }
}
