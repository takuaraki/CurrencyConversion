//
//  CurrencyDBProtocol.swift
//  CurrencyConversion
//
//  Created by ArakiTaku on 2021/01/18.
//

import Foundation

protocol CurrencyDBProtocol {
    func loadSupportedCurrencies() -> [Currency]?
    func saveSupportedCurrencies(currencies: [Currency])
    func loadConversionRates() -> [ConversionRate]?
    func saveConversionRates(exchangeRates: [ConversionRate])
}
