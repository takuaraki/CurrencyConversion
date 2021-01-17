//
//  CurrencyConversionStore.swift
//  CurrencyConversion
//
//  Created by ArakiTaku on 2021/01/18.
//

import Foundation
import RxSwift
import RxCocoa

private let defaultCurrency = Currency(code: "USD", name: "United States Dollar")

class CurrencyConversionStore: CurrencyConversionStoreProtocol {
    // MARK: Outputs
    private(set) lazy var currencies: Driver<[Currency]> = _currencies.asDriver()
    private(set) lazy var selectedCurrency: Driver<Currency> = _selectedCurrency.asDriver()
    private(set) lazy var amount: Driver<Float> = _amount.asDriver()
    private(set) lazy var convertedList: Driver<[Money]> = Driver.combineLatest(
        currencies,
        selectedCurrency,
        amount,
        _conversionRates.asDriver()
    ) { currencies, selectedCurrency, amount, conversionRates -> [Money] in
        guard let selectedCurrencyRate = conversionRates.first(where: { $0.after == selectedCurrency.code }) else { return [] }
        return conversionRates.compactMap { conversionRate -> Money? in
            guard let afterCurrency = currencies.first(where: { $0.code == conversionRate.after }) else { return nil }
            return Money(
                amount: amount / selectedCurrencyRate.rate * conversionRate.rate,
                currency: afterCurrency
            )
        }
    }

    // MARK: Private Properties
    private let _currencies = BehaviorRelay<[Currency]>(value: [])
    private let _selectedCurrency = BehaviorRelay<Currency>(value: defaultCurrency)
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
        repository.getSupportedCurrencies().subscribe(
            onSuccess: { [_currencies] currencies in
                _currencies.accept(currencies)
            }
        ).disposed(by: disposeBag)

        repository.getConversionRates().subscribe(
            onSuccess: { [_conversionRates] conversionRates in
                _conversionRates.accept(conversionRates)
            }
        ).disposed(by: disposeBag)
    }

    func selectCurrency(currency: Currency) {
        _selectedCurrency.accept(currency)
    }

    func setAmount(amount: Float) {
        _amount.accept(amount)
    }
}
