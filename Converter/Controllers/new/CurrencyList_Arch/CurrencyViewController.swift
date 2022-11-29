//
//  CurrencyViewController.swift
//  Converter
//
//  Created by Misha Causur on 23.11.2022.
//

import UIKit
import RxCocoa
import RxSwift

final class CurrencyViewController: UIViewController, ViewType {
    
    typealias ViewModel = CurrencyViewModel
    
    var bindings: ViewModel.Bindings {
        .init(
            searchText: searchBar.rx
                .text
                .compactMap { $0 }
                .asDriver(onErrorJustReturn: .empty),
            didChosenCurrency: tableView.rx
                .modelSelected(Currency.self)
                .asSignal()
        )
    }
    
    /// RX
    private let disposeBag = DisposeBag()
    
    /// UI
    private let activityController = ActivityViewController()
    private let searchController = UISearchController(searchResultsController: nil)
    private var searchBar: UISearchBar { searchController.searchBar }
    private lazy var tableView = UITableView(frame: .zero, style: .grouped).configure { $0.translatesAutoresizingMaskIntoConstraints = false }
    
    /// LC
    override func viewDidLoad() {
        super.viewDidLoad()
        title = .currencies
        configure()
        createLayout()
        definesPresentationContext = true
    }
    
    /// ViewType
    func bind(to viewModel: CurrencyViewModel) {
        
        viewModel.currencies
            .drive(tableView.rx.items(cellIdentifier: .cellID)) { _, currency, cell in
                cell.textLabel?.text = currency.name
            }
            .disposed(by: disposeBag)
        
        viewModel.isLoading
            .drive { [weak self] in
                self?.showActivity($0)
            }
            .disposed(by: disposeBag)
        
        viewModel.disposables
            .disposed(by: disposeBag)
    }
    
    private func configure() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: .cellID)
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
    
    /// Activity Indicator's animating due to loading is in progress
    private func showActivity(_ show: Bool) {
        show ? add(activityController) : activityController.remove()
    }
}
