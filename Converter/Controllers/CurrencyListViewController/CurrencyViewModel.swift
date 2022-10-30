//
//  CurrencyViewModel.swift
//  Converter
//
//  Created by Misha Causur on 29.10.2022.
//

final class CurrencyViewModel: ViewModel {
    let networkService = NetworkService()
    weak var currencyView: CurrencyListViewController?
    func getCurrencies() {
        networkService.getCurrencies { [weak self] result in
            switch result {
            case .success(let currencies):
                self?.currencyView?.reloadView(currencies.sorted { $0.name < $1.name })
            case .failure(let error):
                print(error)
            }
        }
    }
}
