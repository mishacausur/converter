//
//  MainViewModel.swift
//  Converter
//
//  Created by Misha Causur on 28.10.2022.
//

import Foundation
import Combine

final class MainViewModel: ViewModel {
    
    weak var mainView: MainViewController?
    
    private let networkService: NetworkService
    private let dataManager: DataManager
    private var cancellables = Set<AnyCancellable>()

    init(locator: Locator) {
        self.dataManager = locator.dataManager
        self.networkService = locator.networkService
    }
    
    func setupSubscription() {
       
        dataManager.$firstCurrency.removeDuplicates().dropFirst().sink { [weak self] in
            guard let value = $0?.sign else { return }
            self?.changeLabelValue(.upper, value: value)
        }
        .store(in: &cancellables)
        
        dataManager.$secondCurrency.removeDuplicates().dropFirst().sink { [weak self] in
            guard let value = $0?.sign else { return }
            self?.changeLabelValue(.lower, value: value)
        }
        .store(in: &cancellables)
        
        dataManager.$valueEntered.removeDuplicates().dropFirst().sink { [weak self] in
            guard $0 else { return }
            self?.showButton($0)
        }
        .store(in: &cancellables)
    }
    
    func openCurrencyListDidTapped(_ button: CurrencyButton) {
//        coordinator?.route(.currencyList)
        let currencyDidChosen: (Currency) -> Void = { [weak self] in
            guard let self else { return }
            switch self.dataManager.openedFirstCurrency {
            case true:
                self.dataManager.firstCurrency = $0
            case false:
                self.dataManager.secondCurrency = $0
            }
        }
        coordinator?.route(.currencyList_arch(currencyDidChosen))
        switch button {
        case .upper:
            dataManager.openedFirstCurrency = true
        case .lower:
            dataManager.openedFirstCurrency = false
        }
    }
    
    func convertDidTapped() {
        
        guard let first = dataManager.firstCurrency, let second = dataManager.secondCurrency else {
            mainView?.showError(.emptyCurrencies)
            return
        }
        guard first != second else {
            mainView?.showError(.sameValues)
            return
        }
        guard dataManager.lastChangedField == .upper ? dataManager.isFirstValueCorrect : dataManager.isSecondValueCorrect else {
            mainView?.showError(.emptyValues)
            return
        }
        networkService.convertCurrencies(to: dataManager.lastChangedField == .upper ? second.sign : first.sign,
                                 from: dataManager.lastChangedField == .upper ? first.sign : second.sign,
                                 amount: dataManager.lastChangedField == .upper ? dataManager.firstCurrencyValue : dataManager.secondCurrencyValue) { [weak self] result in
            switch result {
            case .success(let value):
                self?.mainView?.setupValueTextFiled(label: self?.dataManager.lastChangedField == .upper ? .lower : .upper, value: value.result)
            case .failure(let error):
                Print.printToConsole(error.localizedDescription)
                self?.mainView?.showError(.undefined)
            }
        }
    }
    
    func setupValues(_ label: CurrencyButton, value: String) {
        guard let number = Int(value) else { return }
        switch label {
        case .upper:
            dataManager.firstCurrencyValue = number
            mainView?.setupValueTextFiled(label: .lower, value: .zero)
            dataManager.lastChangedField = .upper
        case .lower:
            dataManager.secondCurrencyValue = number
            mainView?.setupValueTextFiled(label: .upper, value: .zero)
            dataManager.lastChangedField = .lower
        }
    }
    
    private func changeLabelValue(_ label: CurrencyButton, value: String) {
        mainView?.changeValueLabel(label, value: value)
    }
    
    private func showButton(_ value: Bool) {
        mainView?.showButton(value)
    }
}
