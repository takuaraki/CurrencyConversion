//
//  ConversionRate.swift
//  CurrencyConversion
//
//  Created by ArakiTaku on 2021/01/18.
//

import Foundation

struct ConversionRate: Equatable, Codable {
    let before: CurrencyCode
    let after: CurrencyCode
    let rate: Float
}
