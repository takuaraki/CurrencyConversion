//
//  ConversionRateDTO.swift
//  CurrencyConversion
//
//  Created by ArakiTaku on 2021/01/18.
//

import Foundation

struct ConversionRateDTO: Decodable {
    var quotes: [String : Float]
}
