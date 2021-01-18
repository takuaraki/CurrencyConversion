//
//  CurrencyDBProtocol.swift
//  CurrencyConversion
//
//  Created by ArakiTaku on 2021/01/18.
//

import Foundation

protocol CurrencyDBProtocol {
    func loadConversionRates() -> [ConversionRate]?
    func saveConversionRates(conversionRates: [ConversionRate])
}
