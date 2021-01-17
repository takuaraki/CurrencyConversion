//
//  CurrencyRepository.swift
//  CurrencyConversion
//
//  Created by ArakiTaku on 2021/01/18.
//

import Foundation
import RxSwift

class CurrencyRepository: CurrencyRepositoryProtocol {
    private let api: CurrencyAPIProtocol
    private let db: CurrencyDBProtocol

    init(
        api: CurrencyAPIProtocol,
        db: CurrencyDBProtocol
    ) {
        self.api = api
        self.db = db
    }

    func getSupportedCurrencies() -> Single<[Currency]> {
        return Single<[Currency]>.create { [db, api] observer in
            if let cache = db.loadSupportedCurrencies() {
                observer(.success(cache))
                return Disposables.create()
            }

            let dto = api.getSupportedCurrencies()
            let currencies = dto.currencies.map { code, name -> Currency in
                return Currency(code: code, name: name)
            }.sorted(by: { $0.code < $1.code })

            db.saveSupportedCurrencies(currencies: currencies)

            observer(.success(currencies))

            return Disposables.create()
        }
    }
    
    func getConversionRates() -> Single<[ConversionRate]> {
        return Single<[ConversionRate]>.create { [db, api] observer in
            if let cache = db.loadConversionRates() {
                observer(.success(cache))
                return Disposables.create()
            }

            let dto = api.getConversionRates()
            let rates = dto.quotes.map { codes, rate -> ConversionRate in
                return ConversionRate(
                    before: String(codes[..<codes.index(codes.startIndex, offsetBy: 3)]),
                    after: String(codes[codes.index(codes.startIndex, offsetBy: 3)...]),
                    rate: rate
                )
            }.sorted(by: { $0.after < $1.after })

            db.saveConversionRates(conversionRates: rates)

            observer(.success(rates))

            return Disposables.create()
        }
    }
}
