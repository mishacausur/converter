//
//  CurrencyViewController.swift
//  Converter
//
//  Created by Misha Causur on 23.11.2022.
//

import UIKit
import RxCocoa
import RxSwift
import PinLayout

final class CurrencyListScreenBuilder: ScreenBuilder {
    
    typealias VC = CurrencyViewController
    
    var dependencies: CurrencyViewModel.Dependecies {
        .init(
            networkService: .init(),
            cacheService: .shared
        )
    }
}

final class CurrencyViewController: UIViewController {
    
    private lazy var ui = createUI()
    /// RX
    private let disposeBag = DisposeBag()
    /// LC
    override func viewDidLayoutSubviews() {
        layout()
    }
}

extension CurrencyViewController: ViewType {
    
    typealias ViewModel = CurrencyViewModel
    
    var bindings: ViewModel.Bindings {
        
        let searchText = ui.searchBar.rx
            .text
            .asDriver()
            .compactMap { $0 }
        
        let didSelectModel = ui.table.rx
            .modelSelected(Currency.self)
            .asSignal()
        
        return .init(
            searchText: searchText,
            didSelectModel: didSelectModel
        )
    }
    
    func bind(to viewModel: CurrencyViewModel) {
        
        viewModel.currencies
            .drive(ui.table.rx.items(cellIdentifier: .cellID)) { _, currency, cell in
                cell.textLabel?.text = currency.name
            }
            .disposed(by: disposeBag)
        
        viewModel.isLoading
            .drive(Binder(self) {
                $0.showActivity($1)
            })
            .disposed(by: disposeBag)
        
        viewModel.disposables
            .disposed(by: disposeBag)
    }
}

private extension CurrencyViewController {
    
    struct UI {
        let table: UITableView
        let activity: ActivityViewController
        let searchController: UISearchController
        let searchBar: UISearchBar
    }
    
    func createUI() -> UI {
        title = .currencies
        view.backgroundColor = .white
        definesPresentationContext = true
        let tableView = UITableView(
            frame: .zero,
            style: .grouped
        ).configure {
            $0.register(UITableViewCell.self, forCellReuseIdentifier: .cellID)
            view.addSubview($0)
        }
        
        let searchController = UISearchController(searchResultsController: nil)
        
        let searchBar = searchController.searchBar
        
        searchBar.showsCancelButton = true
        searchBar.placeholder = .searchPlaceholder
        tableView.tableHeaderView = searchBar
        searchController.obscuresBackgroundDuringPresentation = false
        
        return .init(
            table: tableView,
            activity: ActivityViewController(),
            searchController: searchController,
            searchBar: searchBar
        )
    }
    
    func layout() {
        ui.table.pin.all()
    }
    
    func showActivity(_ show: Bool) {
        show ? add(ui.activity) : ui.activity.remove()
        ui.table.isHidden = show
    }
}
