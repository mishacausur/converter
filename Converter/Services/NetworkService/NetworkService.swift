//
//  NetworkService.swift
//  Converter
//
//  Created by Misha Causur on 29.10.2022.
//

import Foundation
import RxSwift

struct NetworkService {
    
    typealias convertHandler = ((Result<Convert, NetworkError>) -> Void)?
    typealias currenciesHandler = ((Result<[Currency], NetworkError>) -> Void)?
    
    func convertCurrencies(to: String, from: String, amount: Int, convertHandler: convertHandler) {
        guard let url = URL(string: [Link.convert.rawValue, createQueryString(to: to, from: from, amount: amount)].reduce(.empty, +)) else {
            convertHandler?(.failure(.badURL))
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue(Security.anotherNewApiKey, forHTTPHeaderField: HTTPHeaders.apikey.rawValue)
        let response = URLSession.shared.dataTask(with: request) { data, _, _ in
            guard let data = data else {
                convertHandler?(.failure(.badData))
                return
            }
            do {
                let value = try JSONDecoder().decode(Convert.self, from: data)
                convertHandler?(.success(value))
            } catch(let error) {
                print(error)
                convertHandler?(.failure(.badDecode))
            }
        }
        response.resume()
    }
    
    func getCurrencies(currenciesHandler: currenciesHandler) {
        guard let url = URL(string: Link.currencies.rawValue) else {
            currenciesHandler?(.failure(.badURL))
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue(Security.anotherNewApiKey, forHTTPHeaderField: HTTPHeaders.apikey.rawValue)
        let response = URLSession.shared.dataTask(with: request) { data, _, _ in
            guard let data = data else {
                currenciesHandler?(.failure(.badData))
                return
            }
            do {
                let symbol = try JSONDecoder().decode(Symbol.self, from: data)
                currenciesHandler?(.success(mapCurrency(symbol.symbols)))
            } catch(let error) {
                print(error)
             //   print(String(data: data, encoding: .utf8)) uncomment due to weird behavior while erroring
                currenciesHandler?(.failure(.badDecode))
            }
        }
        response.resume()
    }
    
    private func mapCurrency(_ response: [String: String]) -> [Currency] {
        response.map { .init(sign: $0.0, name: $0.1) }
    }
    
    private func createQueryString(to: String, from: String, amount: Int) -> String {
        "?to=\(to)&from=\(from)&amount=\(amount)"
    }
}

extension NetworkService {
    
    /// reactive wrapper
    func getCurrencies() -> Single<[Currency]> {
        Single.create { observer in
            self.getCurrencies {
                switch $0 {
                case .success(let currencies):
                    observer(.success(currencies))
                case .failure(let error):
                    observer(.failure(error))
                }
            }
            return Disposables.create()
        }
    }
    
    /// reactive wrapper
    func convertCurrencies(to: String, from: String, amount: Int) -> Single<Convert> {
        Single.create { observer in
            self.convertCurrencies(to: to, from: from, amount: amount) {
                switch $0 {
                case let .success(result):
                    observer(.success(result))
                case let .failure(error):
                    observer(.failure(error))
                }
            }
            return Disposables.create()
        }
    }
}
