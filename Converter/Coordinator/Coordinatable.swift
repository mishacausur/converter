//
//  Coordinatable.swift
//  Converter
//
//  Created by Misha Causur on 28.10.2022.
//

import UIKit.UINavigationController

protocol Coordinatable {
    
    var navigationController: UINavigationController { get set }
    func start()
    func route(_ destination: Route)
}
