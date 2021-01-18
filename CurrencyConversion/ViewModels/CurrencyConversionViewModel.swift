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
    let onCurrencyCodeSelected = PublishRelay<CurrencyCode>()
    let onAmountTextChanged = PublishRelay<String?>()

    // MARK: Outputs
    private(set) lazy var currenciyCodes: Driver<[CurrencyCode]> = store.currencyCodes
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

        onCurrencyCodeSelected.subscribe(onNext: {
            store.selectCurrencyCode(code: $0)
        }).disposed(by: disposeBag)

        onAmountTextChanged
            .compactMap { $0 }
            .map { text -> Float in return Float(text) ?? 0 }
            .subscribe(onNext: {
                store.setAmount(amount: $0)
            }).disposed(by: disposeBag)
    }
}
