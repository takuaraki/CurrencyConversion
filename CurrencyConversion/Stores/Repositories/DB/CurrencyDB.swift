//
//  CurrencyDB.swift
//  CurrencyConversion
//
//  Created by ArakiTaku on 2021/01/18.
//

import Foundation

private let cacheTime: TimeInterval = 30 * 60

class CurrencyDB: CurrencyDBProtocol {
    func loadConversionRates(currentDate: Date = Date()) -> [ConversionRate]? {
        let lastCachedTime = UserDefaults.standard.double(forKey: UserDefaultKey.conversionRatesLastCachedTime.rawValue)
        if currentDate.timeIntervalSince1970 - lastCachedTime > cacheTime {
            return nil
        }

        if let saved = UserDefaults.standard.data(forKey: UserDefaultKey.conversionRates.rawValue) {
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode([ConversionRate].self, from: saved) {
                return decoded
            }
        }
        return nil
    }

    func saveConversionRates(conversionRates: [ConversionRate], currentDate: Date = Date()) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(conversionRates) {
            UserDefaults.standard.set(encoded, forKey: UserDefaultKey.conversionRates.rawValue)
            UserDefaults.standard.setValue(currentDate.timeIntervalSince1970, forKey: UserDefaultKey.conversionRatesLastCachedTime.rawValue)
        }
    }
}

private enum UserDefaultKey: String {
    case conversionRatesLastCachedTime
    case conversionRates
}
