//
//  CurrencyAPIProtocol.swift
//  CurrencyConversion
//
//  Created by ArakiTaku on 2021/01/18.
//

import Foundation

protocol CurrencyAPIProtocol {
    func getConversionRates() -> ConversionRateDTO
}
