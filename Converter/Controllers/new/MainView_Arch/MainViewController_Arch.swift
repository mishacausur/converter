//
//  MainViewController_Arch.swift
//  Converter
//
//  Created by Misha Causur on 25.11.2022.
//

import UIKit
import Combine

final class MainViewController_Arch: UIViewController, ViewType {
    
    // MARK: - ViewType
    typealias ViewModel = MainViewModel_Arch
    var bindings = ViewModel.Bindings()
    
    func bind(to viewModel: MainViewModel_Arch) {
        viewModel.firstCurrency
            .sink { [weak self] in
                guard let currency = $0 else { return }
                DispatchQueue.main.async {
                    self?.upperTextField.configureLabel(currency: currency.sign)
                }
            }
            .store(in: &cancellables)
        
        viewModel.secondCurrency
            .sink { [weak self] in
                guard let currency = $0 else { return }
                DispatchQueue.main.async {
                    self?.lowerTextField.configureLabel(currency: currency.sign)
                }
            }
            .store(in: &cancellables)
        
        viewModel.valueEntered
            .sink { [weak self] in
                self?.button.isHidden = !$0
            }
            .store(in: &cancellables)
        
        viewModel.convertValue
            .replaceError(with: (nil, .upper))
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                guard let result = $0.0 else { return }
                self?.setupValue(result.result, label: $0.1)
            }
            .store(in: &cancellables)
    }
    
    // MARK: - PRIVATE PROPS
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - UI
    private let titleLabel = UILabel().configure {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = .mainViewTitle
        $0.font = .systemFont(ofSize: .largeFontSize, weight: .bold)
    }
    private let upperTextField = MainViewTextField()
    private let lowerTextField = MainViewTextField()
    private let button = UIFactory.createButton(with: .convert).configure { $0.isHidden = true }
    
    /// Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addViews()
        layout()
        bindActions()
    }
    
    private func addViews() {
        view.addViews(titleLabel, upperTextField, lowerTextField, button)
    }
    
    private func layout() {
        [upperTextField, lowerTextField].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        NSLayoutConstraint.activate  {
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 122)
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            upperTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            upperTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: .titleInset)
            lowerTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            lowerTextField.topAnchor.constraint(equalTo: upperTextField.bottomAnchor, constant: .defaultInset)
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            button.topAnchor.constraint(equalTo: lowerTextField.bottomAnchor, constant: .defaultInset)
            button.widthAnchor.constraint(equalToConstant: .defaultWidth)
            button.heightAnchor.constraint(equalToConstant: .defaultHeight)
        }
    }
    
    private func bindActions() {
        button.addTarget(self, action: #selector(buttonDidTapped), for: .touchUpInside)
        
        upperTextField.buttonDidTapped = { [weak self] in
            self?.bindings.buttonDidTapped?(.upper)
        }
        lowerTextField.buttonDidTapped = { [weak self] in
            self?.bindings.buttonDidTapped?(.lower)
        }
        upperTextField.valueDidEntered = { [weak self] in
            self?.bindings.fieldValueEntered?((.upper, $0))
        }
        lowerTextField.valueDidEntered = { [weak self] in
            self?.bindings.fieldValueEntered?((.lower, $0))
        }
    }
    
    private func setupValue(_ value: Double, label: CurrencyButton) {
        DispatchQueue.main.async { [weak self] in
            switch label {
            case .upper:
                self?.upperTextField.value = value
            case .lower:
                self?.lowerTextField.value = value
            }
        }
    }
    
    @objc private func buttonDidTapped() {
        bindings.convertButtonDidTapped?()
    }
}
