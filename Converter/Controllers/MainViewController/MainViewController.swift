//
//  MainViewController.swift
//  Converter
//
//  Created by Misha Causur on 28.10.2022.
//
import Foundation

final class MainViewController: ViewController<MainView, MainViewModel> {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    private func configure() {
        viewModel.setupSubscription()
        mainView.currencyButtonDidTapped = { [weak self] in
            self?.viewModel.openCurrencyListDidTapped($0)
        }
        mainView.currencyValueDidEnter = { [weak self] in
            self?.viewModel.setupValues($0, value: $1)
        }
        mainView.addTarget(self, buttonDidTapped: #selector(convertButtonDidTapped))
    }
    
    func changeValueLabel(_ label: CurrencyButton, value: String) {
        mainView.changeValueLabel(label, value: value)
    }
    
    @objc private func convertButtonDidTapped() {
        viewModel.convertDidTapped()
    }
    
    func setupValueTextFiled(label: CurrencyButton, value: Double) {
        mainView.setupTextFieldValue(label, value: value)
    }
}
