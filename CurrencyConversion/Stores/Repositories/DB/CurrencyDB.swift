//
//  CurrencyDB.swift
//  CurrencyConversion
//
//  Created by ArakiTaku on 2021/01/18.
//

import Foundation

class CurrencyDB: CurrencyDBProtocol {
    func loadConversionRates() -> [ConversionRate]? {
        if let saved = UserDefaults.standard.data(forKey: UserDefaultKey.conversionRates.rawValue) {
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode([ConversionRate].self, from: saved) {
                return decoded
            }
        }
        return nil
    }

    func saveConversionRates(conversionRates: [ConversionRate]) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(conversionRates) {
            UserDefaults.standard.set(encoded, forKey: UserDefaultKey.conversionRates.rawValue)
        }
    }
}

private enum UserDefaultKey: String {
    case conversionRates
}
