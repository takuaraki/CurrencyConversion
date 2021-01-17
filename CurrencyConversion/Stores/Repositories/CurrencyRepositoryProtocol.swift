//
//  CurrencyRepositoryProtocol.swift
//  CurrencyConversion
//
//  Created by ArakiTaku on 2021/01/18.
//

import Foundation
import RxSwift

protocol CurrencyRepositoryProtocol {
    func getSupportedCurrencies() -> Single<[Currency]>
    func getConversionRates() -> Single<[ConversionRate]>
}
