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

    func getConversionRates() -> Single<[ConversionRate]> {
        return Single<[ConversionRate]>.create { [db, api] observer in
            if let cache = db.loadConversionRates(currentDate: Date()) {
                observer(.success(cache))
                return Disposables.create()
            }

            api.getConversionRates(onSuccess: { dto in
                let rates = dto.convert().sorted(by: { $0.after < $1.after })
                db.saveConversionRates(conversionRates: rates, currentDate: Date())

                observer(.success(rates))
            }, onError: { error in
                observer(.error(error))
            })

            return Disposables.create()
        }
    }
}
