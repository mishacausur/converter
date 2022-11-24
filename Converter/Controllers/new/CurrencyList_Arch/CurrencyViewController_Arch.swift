//
//  CurrencyViewController_Arch.swift
//  Converter
//
//  Created by Misha Causur on 23.11.2022.
//

import UIKit
import Combine

final class CurrencyViewController_Arch: UIViewController, ViewType {
    
    typealias ViewModel = CurrencyViewModel_Arch
    
    var bindings = ViewModel.Bindings()
    
    var currencyDidChosen: ((Currency) -> Void)?
    var items: [Currency] = []
    var filteredItems: [Currency] = []
    var isFiltered = false
    var cancellables = Set<AnyCancellable>()
    let searchController = UISearchController(searchResultsController: nil)
    var searchBar: UISearchBar { searchController.searchBar }
    private lazy var tableView = UITableView(frame: .zero, style: .grouped).configure { $0.translatesAutoresizingMaskIntoConstraints = false }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        createLayout()
        definesPresentationContext = true
    }
    
    func bind(to viewModel: CurrencyViewModel_Arch) {
        
        currencyDidChosen = bindings.setupCurrencies
        guard let items = viewModel.currencies else {
            viewModel.publishedCurrencies?
                .replaceError(with: [])
                .receive(on: DispatchQueue.main)
                .sink { [weak self] in
                    self?.items = $0.sorted { $0.name < $1.name }
                    self?.tableView.reloadData()
                }
                .store(in: &cancellables)
            return
        }
        self.items = items
    }
    
    private func configure() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: .cellID)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
    }
    
    private func createLayout() {
        view.addViews(tableView)
        
        NSLayoutConstraint.activate  {
            tableView.topAnchor.constraint(equalTo: view.topAnchor)
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        }
        searchBar.showsCancelButton = true
        searchBar.placeholder = "Search for currency"
        tableView.tableHeaderView = searchController.searchBar
    }
}

// MARK: - TableView
extension CurrencyViewController_Arch: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch isFiltered {
        case true:
            return filteredItems.count
        case false:
            return items.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: .cellID, for: indexPath)
        cell.textLabel?.text = isFiltered ? filteredItems[indexPath.row].name : items[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let title = isFiltered ? filteredItems[indexPath.row] : items[indexPath.row]
        currencyDidChosen?(title)
    }
}

// MARK: - Searching
extension CurrencyViewController_Arch: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        if !text.isEmpty {
            isFiltered = true
        } else {
            isFiltered = false
        }
        search(text)
    }
    
    private func search(_ searchText: String) {
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            
            self.filteredItems = self.items.filter { $0.name.lowercased().contains(searchText.lowercased()) }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}
