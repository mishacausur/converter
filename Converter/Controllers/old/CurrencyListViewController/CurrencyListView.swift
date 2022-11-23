//
//  CurrencyListView.swift
//  Converter
//
//  Created by Misha Causur on 29.10.2022.
//

import UIKit

final class CurrencyListView: Viеw {
    
    let searchController = UISearchController(searchResultsController: nil)
    private lazy var tableView = UITableView(frame: .zero, style: .grouped).configure { $0.translatesAutoresizingMaskIntoConstraints = false }
    var currencyDidChosen: ((Currency) -> Void)?
    var items: [Currency] = [] {
        didSet {
            guard items.count > 0 else { return }
            reloadView()
        }
    }
    var filteredItems: [Currency] = []
    var isFiltered = false
    
    override func configure() {
        super.configure()
        backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: .cellID)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
    }
    
    override func addViews() {
        addViews(tableView)
    }
    
    override func layout() {
        NSLayoutConstraint.activate  {
            tableView.topAnchor.constraint(equalTo: topAnchor)
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor)
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor)
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        }
    }
    
    func reloadView() {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
}

// MARK: - TableView
extension CurrencyListView: UITableViewDelegate, UITableViewDataSource {
    
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
extension CurrencyListView: UISearchResultsUpdating {
    
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
