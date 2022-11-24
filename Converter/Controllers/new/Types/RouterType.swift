//
//  RouterType.swift
//  Converter
//
//  Created by Misha Causur on 23.11.2022.
//

protocol RouterType {
    
    associatedtype TransitionHandler
    
    init(transitionHandler: TransitionHandler)
}
