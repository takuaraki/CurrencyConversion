//
//  CurrencyConversionStore.swift
//  CurrencyConversion
//
//  Created by ArakiTaku on 2021/01/18.
//

import Foundation
import RxSwift
import RxCocoa

private let defaultCurrencyCode = "USD"

class CurrencyConversionStore: CurrencyConversionStoreProtocol {
    // MARK: Outputs
    private(set) lazy var currencyCodes: Driver<[CurrencyCode]> = _conversionRates.asDriver().map { $0.map { $0.after } }
    private(set) lazy var selectedCurrencyCode: Driver<CurrencyCode> = _selectedCurrencyCode.asDriver()
    private(set) lazy var amount: Driver<Float> = _amount.asDriver()
    private(set) lazy var convertedList: Driver<[Money]> = Driver.combineLatest(
        selectedCurrencyCode,
        amount,
        _conversionRates.asDriver()
    ) { selectedCurrencyCode, amount, conversionRates -> [Money] in
        guard let selectedCurrencyRate = conversionRates.first(where: { $0.after == selectedCurrencyCode }) else { return [] }
        return conversionRates.compactMap { conversionRate -> Money? in
            return Money(
                amount: amount / selectedCurrencyRate.rate * conversionRate.rate,
                currencyCode: conversionRate.after
            )
        }
    }

    // MARK: Private Properties
    private let _selectedCurrencyCode = BehaviorRelay<CurrencyCode>(value: defaultCurrencyCode)
    private let _amount = BehaviorRelay<Float>(value: 0)
    private let _conversionRates = BehaviorRelay<[ConversionRate]>(value: [])

    private let repository: CurrencyRepositoryProtocol

    private let disposeBag = DisposeBag()

    init(
        repository: CurrencyRepositoryProtocol
    ) {
        self.repository = repository
    }

    func load() {
        repository.getConversionRates().subscribe(
            onSuccess: { [_conversionRates] conversionRates in
                _conversionRates.accept(conversionRates)
            }
        ).disposed(by: disposeBag)
    }

    func selectCurrencyCode(code: CurrencyCode) {
        _selectedCurrencyCode.accept(code)
    }

    func setAmount(amount: Float) {
        _amount.accept(amount)
    }
}
