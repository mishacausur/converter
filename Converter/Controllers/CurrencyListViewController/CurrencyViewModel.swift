//
//  CurrencyViewModel.swift
//  Converter
//
//  Created by Misha Causur on 29.10.2022.
//

final class CurrencyViewModel: ViewModel {
    var isUpper: Bool = true
    let dataManager: DataManager
    let networkService: NetworkService
    weak var currencyView: CurrencyListViewController?
    
    init(locator: Locator) {
        self.dataManager = locator.dataManager
        self.networkService = locator.networkService
    }
    
    func getCurrencies() {
        networkService.getCurrencies { [weak self] result in
            switch result {
            case .success(let currencies):
                self?.currencyView?.reloadView(currencies.sorted { $0.name < $1.name })
            case .failure(let error):
                Print.printToConsole(error.localizedDescription)
                self?.currencyView?.showError(.undefined)
            }
        }
    }
    
    func setupCurrency(_ currency: Currency) {
        switch dataManager.openedFirstCurrency {
        case true:
            dataManager.firstCurrency = currency
        case false:
            dataManager.secondCurrency = currency
        }
        coordinator?.route(.dismiss)
    }
}
