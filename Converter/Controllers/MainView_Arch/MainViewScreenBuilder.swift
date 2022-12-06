//
//  MainViewScreenBuilder.swift
//  Converter
//
//  Created by Misha Causur on 25.11.2022.
//

final class MainViewScreenBuilder: ScreenBuilder {
    
    var dependencies: MainViewModel_Arch.Dependencies {
        .init(networkService: .init())
    }
    
    typealias VC = MainViewController_Arch
}
