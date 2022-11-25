//
//  Route.swift
//  Converter
//
//  Created by Misha Causur on 28.10.2022.
//

enum Route {
    case currencyList
    case dismiss
    case currencyList_arch(((Currency) -> Void))
}
