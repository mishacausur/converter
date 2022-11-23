//
//  RouterType.swift
//  Converter
//
//  Created by Миша on 23.11.2022.
//

protocol RouterType {
    
    associatedtype TransitionHandler
    
    init(transitionHandler: TransitionHandler)
}
