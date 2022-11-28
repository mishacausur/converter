//
//  CurrencyViewController_Arch.swift
//  Converter
//
//  Created by Misha Causur on 23.11.2022.
//

import UIKit
import RxCocoa
import RxSwift

final class CurrencyViewController_Arch: UIViewController, ViewType {
    
    typealias ViewModel = CurrencyViewModel_Arch
    
    var bindings: ViewModel.Bindings {
        .init(searchText: searchText.asDriver(),
              didChosenCurrency: didChosenCurrency.asSignal())
    }

    private let searchText = BehaviorRelay(value: "")
    private let didChosenCurrency = PublishRelay<Currency>()
    private let disposeBag = DisposeBag()
    private let activityController = ActivityViewController()
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
         
        tableView.rx
            .modelSelected(Currency.self)
            .subscribe(onNext: { [weak completion = self.didChosenCurrency] in
                completion?.accept($0) })
            .disposed(by: disposeBag)
        
        viewModel.currencies
            .asObservable()
            .bind(to: tableView.rx.items(cellIdentifier: .cellID)) { _, currency, cell in
            cell.textLabel?.text = currency.name
        }
        .disposed(by: disposeBag)

        viewModel.isLoading
            .drive { [weak self] in
                self?.showActivity(!$0)
            }
            .disposed(by: disposeBag)
        
        viewModel.disposables
            .disposed(by: disposeBag)
    }

    private func configure() {
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
    
    private func showActivity(_ show: Bool) {
        show ? add(activityController) : activityController.remove()
    }
}

// MARK: - Searching
extension CurrencyViewController_Arch: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        searchText.accept(text)
    }
}
