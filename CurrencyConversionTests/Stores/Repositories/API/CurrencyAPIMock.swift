//
//  CurrencyAPIMock.swift
//  CurrencyConversionTests
//
//  Created by ArakiTaku on 2021/01/18.
//

@testable import CurrencyConversion
import Foundation

class CurrencyAPIMock: CurrencyAPIProtocol {
    var conversionRates = ConversionRateDTO(quotes: [:])

    func getConversionRates(onSuccess: @escaping (ConversionRateDTO) -> Void, onError: @escaping (Error) -> Void) {
        onSuccess(conversionRates)
    }
}
