//
//  CurrencyAPIMock.swift
//  CurrencyConversionTests
//
//  Created by ArakiTaku on 2021/01/18.
//

@testable import CurrencyConversion
import Foundation

class CurrencyAPIMock: CurrencyAPIProtocol {
    var supportedCurrencies = SupportedCurrenciesDTO(currencies: [:])
    var conversionRates = ConversionRateDTO(quotes: [:])

    func getSupportedCurrencies() -> SupportedCurrenciesDTO {
        return supportedCurrencies
    }
    
    func getConversionRates() -> ConversionRateDTO {
        return conversionRates
    }
}
