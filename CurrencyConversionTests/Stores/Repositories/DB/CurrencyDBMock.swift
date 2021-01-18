//
//  CurrencyDBMock.swift
//  CurrencyConversionTests
//
//  Created by ArakiTaku on 2021/01/18.
//

@testable import CurrencyConversion
import Foundation

class CurrencyDBMock: CurrencyDBProtocol {
    var conversionRates: [ConversionRate]? = nil

    func loadConversionRates() -> [ConversionRate]? {
        return conversionRates
    }

    func saveConversionRates(conversionRates: [ConversionRate]) {
        self.conversionRates = conversionRates
    }
}
