//
//  CurrencyViewModel_Arch.swift
//  Converter
//
//  Created by Миша on 23.11.2022.
//

struct CurrencyViewModel_Arch: ViewModelType {
   
    var _currencies: CurrencyResult
    
    /// При наличии в кеше будут переданы сюда, в противном случае нужен сетевой запрос
    struct Inputs {
        let currencies: [Currency]?
        
        var isEmpty: Bool {
            return currencies == nil
        }
    }
    
    struct Bindings {
        var setupCurrencies: (Currency) -> Void = { _ in }
    }
    
    struct Dependecies {
        let dataManager: DataManager
        let networkService: NetworkService
    }
    
    static func configure(input: Inputs, binding: Bindings, dependency: Dependecies, router: EmptyRouter) -> CurrencyViewModel_Arch {
        guard let items = input.currencies else {
            var result: CurrencyResult = .initialized
            dependency.networkService.getCurrencies {
                switch $0 {
                case .success(let items):
                    result = .items(items.sorted { $0.name < $1.name })
                case .failure(let error):
                    result = .error(error)
                }
            }
            return .init(_currencies: result)
        }
        return .init(_currencies: .items(items))
    }
}

enum CurrencyResult {
    case items([Currency])
    case error(NetworkError)
    case initialized
}

