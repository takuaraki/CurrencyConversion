//
//  CurrencyRepositoryMock.swift
//  CurrencyConversionTests
//
//  Created by ArakiTaku on 2021/01/18.
//

@testable import CurrencyConversion
import Foundation
import RxSwift

class CurrencyRepositoryMock: CurrencyRepositoryProtocol {
    var supportedCurrencies: [Currency] = []
    var conversionRates: [ConversionRate] = []

    func getSupportedCurrencies() -> Single<[Currency]> {
        return Single.just(supportedCurrencies)
    }

    func getConversionRates() -> Single<[ConversionRate]> {
        return Single.just(conversionRates)
    }
}
