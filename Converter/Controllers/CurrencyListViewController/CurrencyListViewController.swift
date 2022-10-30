//
//  CurrencyListViewController.swift
//  Converter
//
//  Created by Misha Causur on 29.10.2022.
//

final class CurrencyListViewController: ViewController<CurrencyListView, CurrencyViewModel> {
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.searchController = mainView.searchController
        viewModel.getCurrencies()
    }
    
    func reloadView(_ value: [Currency]) {
        mainView.items = value
    }
}
