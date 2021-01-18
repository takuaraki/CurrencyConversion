//
//  CurrencyAPIProtocol.swift
//  CurrencyConversion
//
//  Created by ArakiTaku on 2021/01/18.
//

import Foundation

protocol CurrencyAPIProtocol {
    func getConversionRates(onSuccess: @escaping (ConversionRateDTO) -> Void, onError: @escaping (Error) -> Void)
}
