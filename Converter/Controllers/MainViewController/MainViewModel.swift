//
//  MainViewModel.swift
//  Converter
//
//  Created by Misha Causur on 28.10.2022.
//

import Foundation

final class MainViewModel: ViewModel {
    
    func openCurrencyListDidTapped() {
        coordinator?.route(.currencyList)
    }
    
}
