//
//  MainViewModel.swift
//  Converter
//
//  Created by Misha Causur on 28.10.2022.
//

import Foundation
import Combine

final class MainViewModel: ViewModel {
    
    private let dataManager: DataManager
    private var cancellables = Set<AnyCancellable>()
    weak var mainView: MainViewController?
    
    init(dataManager: DataManager) {
        self.dataManager = dataManager
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
    }
    
    func openCurrencyListDidTapped(_ button: CurrencyButton) {
        coordinator?.route(.currencyList)
        switch button {
        case .upper:
            dataManager.openedFirstCurrency = true
        case .lower:
            dataManager.openedFirstCurrency = false
        }
    }
    
    func convertDidTapped() {
        let ntwrkr = NetworkService()
        guard let first = dataManager.firstCurrency, let second = dataManager.secondCurrency else {
            mainView?.showError("You haven't chose any currency", message: "Please, chose both of the currencies to allow exchange 'em")
            return
        }
        guard first != second else {
            mainView?.showError("You've chosen the same values of currencies", message: "Exchange currency into itself doesn't have any meaning")
            return
        }
        guard dataManager.lastChangedField == .upper ? dataManager.firstCurrencyValue > 0 : dataManager.secondCurrencyValue > 0 else {
            mainView?.showError("You need to enter the value", message: "Enter a number of currency you want to exchange")
            return
        }
        ntwrkr.convertCurrencies(to: dataManager.lastChangedField == .upper ? second.sign : first.sign,
                                 from: dataManager.lastChangedField == .upper ? first.sign : second.sign,
                                 amount: dataManager.lastChangedField == .upper ? dataManager.firstCurrencyValue : dataManager.secondCurrencyValue) { [weak self] result in
            switch result {
            case .success(let value):
                self?.mainView?.setupValueTextFiled(label: self?.dataManager.lastChangedField == .upper ? .lower : .upper, value: value.result)
            case .failure(let error):
                print(error)
                self?.mainView?.showError("Error has occured", message: "Something goes wrong but we're already working to fix it")
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
    
}
