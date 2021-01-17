//
//  SupportedCurrenciesDTO.swift
//  CurrencyConversion
//
//  Created by ArakiTaku on 2021/01/18.
//

import Foundation

struct SupportedCurrenciesDTO: Decodable {
    var currencies: [String : String]
}
