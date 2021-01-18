//
//  CurrencyDBProtocol.swift
//  CurrencyConversion
//
//  Created by ArakiTaku on 2021/01/18.
//

import Foundation

protocol CurrencyDBProtocol {
    func loadConversionRates(currentDate: Date) -> [ConversionRate]?
    func saveConversionRates(conversionRates: [ConversionRate], currentDate: Date)
}
