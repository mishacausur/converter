//
//  Print.swift
//  Converter
//
//  Created by Misha Causur on 30.10.2022.
//

import Foundation

final class Print {
    static func printToConsole(_ message : String) {
#if DEBUG
        print(message)
#endif
    }
}
