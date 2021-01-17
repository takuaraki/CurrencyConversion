//
//  CurrencyAPIProtocol.swift
//  CurrencyConversion
//
//  Created by ArakiTaku on 2021/01/18.
//

import Foundation
import RxSwift

protocol CurrencyAPIProtocol {
    func getSupportedCurrencies() -> Single<SupportedCurrenciesDTO>
    func getUSDExchangeRates() -> Single<[ConversionRateDTO]>
}
