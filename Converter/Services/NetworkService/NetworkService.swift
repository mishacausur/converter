//
//  NetworkService.swift
//  Converter
//
//  Created by Misha Causur on 29.10.2022.
//

import Foundation

struct NetworkService {
    
    typealias convertHandler = ((Result<Convert, NetworkError>) -> Void)?
    typealias currenciesHandler = ((Result<[Currency], NetworkError>) -> Void)?
    
    static func convertCurrencies(to: String, from: String, amount: Int, convertHandler: convertHandler) {
        let url = Link.convert.rawValue + "?to=\(to)&from=\(from)&amount=\(amount)"
       
    }
    
    func getCurrencies(currenciesHandler: currenciesHandler) {
        guard let url = URL(string: Link.currencies.rawValue) else {
            currenciesHandler?(.failure(.badURL))
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue(Security.apiKey, forHTTPHeaderField: HTTPHeaders.apikey.rawValue)
        let response = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                currenciesHandler?(.failure(.badData))
                return
            }
            do {
                let symbol = try JSONDecoder().decode(Symbol.self, from: data)
                currenciesHandler?(.success(mapCurrency(symbol.symbols)))
            } catch(let error) {
                print(error)
                currenciesHandler?(.failure(.badDecode))
            }
        }
        response.resume()
    }
    
    private func mapCurrency(_ response: [String: String]) -> [Currency] {
        response.map { .init(sign: $0.0, name: $0.1) }
    }
}

enum Link: String {
    case currencies = "https://api.apilayer.com/exchangerates_data/symbols"
    case convert = "https://api.apilayer.com/exchangerates_data/convert"
}

enum HTTPHeaders: String {
    case apikey = "apikey"
}

enum NetworkError: Error {
    case badURL
    case badData
    case badDecode
}

enum Security {}
extension Security {
    static let apiKey = ""
}
