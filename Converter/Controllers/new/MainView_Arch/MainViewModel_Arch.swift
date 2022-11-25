//
//  MainViewModel_Arch.swift
//  Converter
//
//  Created by Misha Causur on 25.11.2022.
//

import Combine

struct MainViewModel_Arch {
    let firstCurrency: any Publisher<Currency?, Never>
    let secondCurrency: any Publisher<Currency?, Never>
    let valueEntered: any Publisher<Bool, Never>
    let convertValue: AnyPublisher<Convert?, NetworkError>
}

extension MainViewModel_Arch: ViewModelType {
    
    typealias Inputs = Void
    
    class Bindings {
        var buttonDidTapped: ((CurrencyButton) -> Void)?
        var fieldValueEntered: (((CurrencyButton, String)) -> Void)?
        var convertButtonDidTapped: (() -> Void)?
    }
    
    struct Dependecies {
        let networkService: NetworkService
        let dataManager: DataManager
    }
    
    typealias Router = MainViewRouter
    
    static func configure(input: Inputs, binding: Bindings, dependency: Dependecies, router: Router) -> MainViewModel_Arch {
        let subject = CurrentValueSubject<Convert?, NetworkError>(nil)
        let lastUpdated = CurrentValueSubject<CurrencyButton, Never>(.upper)
        
        let currencyDidChosen: (Currency) -> Void = {
            switch dependency.dataManager.openedFirstCurrency {
            case true:
                dependency.dataManager.firstCurrency = $0
            case false:
                dependency.dataManager.secondCurrency = $0
            }
        }
        
        binding.buttonDidTapped = {
            switch $0 {
            case .upper:
                dependency.dataManager.openedFirstCurrency = true
            case .lower:
                dependency.dataManager.openedFirstCurrency = false
            }
            router.startCurrencyListFlow(currencyDidChosen)
        }
        
        binding.fieldValueEntered = {
            guard let number = Int($0.1) else { return }
            switch $0.0 {
            case .upper:
                dependency.dataManager.firstCurrencyValue = number
                lastUpdated.value = .upper
            case .lower:
                dependency.dataManager.secondCurrencyValue = number
                lastUpdated.value = .lower
            }
        }
        
        binding.convertButtonDidTapped = {
            _ = convert(subject,
                    lastUpdated.value,
                    networkService: dependency.networkService,
                    dataManager: dependency.dataManager)
        }
        
        return .init(firstCurrency: dependency.dataManager.$firstCurrency,
                     secondCurrency: dependency.dataManager.$secondCurrency,
                     valueEntered: dependency.dataManager.$valueEntered,
                     convertValue: convert(subject,
                                           lastUpdated.value,
                                           networkService: dependency.networkService,
                                           dataManager: dependency.dataManager))
    }
    
    static func convert(_ subject: CurrentValueSubject<Convert?, NetworkError>, _ last: CurrencyButton, networkService: NetworkService, dataManager: DataManager) -> AnyPublisher<Convert?, NetworkError> {
        
        guard let first = dataManager.firstCurrency,
              let second = dataManager.secondCurrency,
              first != second,
              last == .upper
                ? dataManager.isFirstValueCorrect
                : dataManager.isSecondValueCorrect else {
            return subject.eraseToAnyPublisher()
        }
        let from = last == .upper ? first.sign : second.sign
        let to = last == .upper ? second.sign : first.sign
        let amount = last == .upper ? dataManager.firstCurrencyValue : dataManager.secondCurrencyValue
        networkService.convertCurrencies(to: to, from: from, amount: amount) {
            switch $0 {
            case .success(let value):
                subject.send(value)
            case .failure(let error):
                subject.send(completion: .failure(error))
            }
        }
        return subject.eraseToAnyPublisher()
    }
}
