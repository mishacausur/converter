//
//  ViewModel.swift
//  Converter
//
//  Created by Misha Causur on 28.10.2022.
//

import Foundation

protocol ViewInput: AnyObject {}

protocol ViewOutput: Coordinated {}

class ViewModel: ViewOutput {
    
    var coordinator: Coordinatable?
    weak var view: ViewInput?
    
}
