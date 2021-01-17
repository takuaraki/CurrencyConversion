//
//  CurrencyConversionStoreProtocol.swift
//  CurrencyConversion
//
//  Created by ArakiTaku on 2021/01/18.
//

import Foundation
import RxCocoa

protocol CurrencyConversionStoreProtocol {
    // MARK: Outputs
    var currencies: Driver<[Currency]> { get }
    var selectedCurrencies: Driver<Currency> { get }
    var amount: Driver<Float> { get }
    var convertedList: Driver<[Money]> { get }

    // MARK: Inputs
    func selectCurrency(currency: Currency)
    func setAmount(amount: Float)
}
