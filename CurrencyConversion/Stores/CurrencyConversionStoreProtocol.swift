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
    var currencyCodes: Driver<[CurrencyCode]> { get }
    var selectedCurrencyCode: Driver<CurrencyCode> { get }
    var amount: Driver<Float> { get }
    var convertedList: Driver<[Money]> { get }

    // MARK: Inputs
    func load()
    func selectCurrencyCode(code: CurrencyCode)
    func setAmount(amount: Float)
}
