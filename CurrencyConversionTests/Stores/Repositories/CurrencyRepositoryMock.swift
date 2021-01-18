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
    var conversionRates: [ConversionRate] = []

    func getConversionRates() -> Single<[ConversionRate]> {
        return Single.just(conversionRates)
    }
}
