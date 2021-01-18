//
//  ConversionRateDTO.swift
//  CurrencyConversion
//
//  Created by ArakiTaku on 2021/01/18.
//

import Foundation

struct ConversionRateDTO: Decodable {
    var quotes: [String : Float]

    func convert() -> [ConversionRate] {
        return self.quotes.map { codes, rate -> ConversionRate in
            return ConversionRate(
                before: String(codes[..<codes.index(codes.startIndex, offsetBy: 3)]),
                after: String(codes[codes.index(codes.startIndex, offsetBy: 3)...]),
                rate: rate
            )
        }
    }
}
