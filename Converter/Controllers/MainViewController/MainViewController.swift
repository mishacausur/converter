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
        mainView.addTargetUpperTextField(self, buttonDidTapped: #selector(openCurrencyListDidTapped))
        mainView.addTargetLowerTextField(self, buttonDidTapped: #selector(openCurrencyListDidTapped))
    }
    @objc private func openCurrencyListDidTapped() {
        viewModel.openCurrencyListDidTapped()
    }
    
}
