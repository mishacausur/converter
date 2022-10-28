//
//  MainView.swift
//  Converter
//
//  Created by Misha Causur on 28.10.2022.
//

import UIKit

final class MainView: Viеw {
    
    let view = MainBaseView().configure { $0.translatesAutoresizingMaskIntoConstraints = false }
    
    override func configure() {
        super.configure()
        backgroundColor = .white
    }
    
    override func addViews() {
        addViews(view)
    }
    
    override func layout() {
        [view.centerXAnchor.constraint(equalTo: centerXAnchor),
         view.centerYAnchor.constraint(equalTo: centerYAnchor)].forEach { $0.isActive = true }
    }
}
