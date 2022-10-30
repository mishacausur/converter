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
    var items: [Currency] = [] {
        didSet {
            guard items.count > 0 else { return }
            reloadView()
        }
    }
    override func configure() {
        super.configure()
        backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    override func addViews() {
        addViews(tableView)
    }
    
    override func layout() {
        [tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
         tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
         tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
         tableView.bottomAnchor.constraint(equalTo: bottomAnchor)].forEach { $0.isActive = true }
    }
    
    func reloadView() {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
}

extension CurrencyListView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = items[indexPath.row].name
        return cell
    }
}
