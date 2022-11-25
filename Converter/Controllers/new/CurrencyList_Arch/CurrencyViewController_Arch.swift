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
    private var items: [Currency] = []
    private var cancellables = Set<AnyCancellable>()
    
    private let searchController = UISearchController(searchResultsController: nil)
    private var searchBar: UISearchBar { searchController.searchBar }
    private lazy var tableView = UITableView(frame: .zero, style: .grouped).configure { $0.translatesAutoresizingMaskIntoConstraints = false }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        createLayout()
        definesPresentationContext = true
    }
    
    func bind(to viewModel: CurrencyViewModel_Arch) {
        
        viewModel.publishedCurrencies
            .replaceError(with: [])
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.items = $0
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
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
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: .cellID, for: indexPath)
        cell.textLabel?.text = items[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let title = items[indexPath.row]
        bindings.currencyDidChosen?(title)
    }
}

// MARK: - Searching
extension CurrencyViewController_Arch: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        bindings.searchText?(text)
    }
}
