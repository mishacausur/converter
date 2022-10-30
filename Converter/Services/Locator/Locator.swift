//
//  Locator.swift
//  Converter
//
//  Created by Misha Causur on 30.10.2022.
//

import Foundation

final class Locator {
    let networkService: NetworkService
    let dataManager: DataManager
    
    init() {
        self.networkService = .init()
        self.dataManager = .init()
    }
}
