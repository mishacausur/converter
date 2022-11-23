//
//  CurrencyListViewController.swift
//  Converter
//
//  Created by Misha Causur on 29.10.2022.
//

final class CurrencyListViewController: ViewController<CurrencyListView, CurrencyViewModel> {
    
    let activity = ActivityViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        add(activity)
        navigationItem.searchController = mainView.searchController
        title = .currencies
        viewModel.getCurrencies()
        mainView.currencyDidChosen = { [weak self] in
            self?.viewModel.setupCurrency($0) }
    }
   
    func reloadView(_ value: [Currency]) {
        activity.remove()
        mainView.items = value
    }
}
