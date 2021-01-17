//
//  CurrencyConversionViewModel.swift
//  CurrencyConversion
//
//  Created by ArakiTaku on 2021/01/18.
//

import Foundation
import RxSwift
import RxCocoa

class CurrencyConversionViewModel {
    // MARK: Inputs
    let onViewDidLoad = PublishRelay<Void>()
    let onCurrencySelected = PublishRelay<Currency>()
    let onAmountTextChanged = PublishRelay<String?>()

    // MARK: Outputs
    private(set) lazy var currencies: Driver<[Currency]> = store.currencies
    private(set) lazy var convertedList: Driver<[Money]> = store.convertedList

    private let store: CurrencyConversionStoreProtocol

    private let disposeBag = DisposeBag()
    init(
        store: CurrencyConversionStoreProtocol
    ) {
        self.store = store

        onViewDidLoad.subscribe(onNext: { _ in
            store.load()
        }).disposed(by: disposeBag)

        onCurrencySelected.subscribe(onNext: {
            store.selectCurrency(currency: $0)
        }).disposed(by: disposeBag)

        onAmountTextChanged
            .compactMap { $0 }
            .map { text -> Float in return Float(text) ?? 0 }
            .subscribe(onNext: {
                store.setAmount(amount: $0)
            }).disposed(by: disposeBag)
    }
}
