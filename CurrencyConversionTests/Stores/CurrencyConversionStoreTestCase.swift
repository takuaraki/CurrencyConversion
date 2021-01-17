//
//  CurrencyConversionStoreTestCase.swift
//  CurrencyConversionTests
//
//  Created by ArakiTaku on 2021/01/18.
//

@testable import CurrencyConversion
import XCTest
import RxSwift

class CurrencyConversionStoreTestCase: XCTestCase {
    var repository: CurrencyRepositoryMock!
    var store: CurrencyConversionStore!

    let disposeBag = DisposeBag()

    override func setUpWithError() throws {
        repository = CurrencyRepositoryMock()
        store = CurrencyConversionStore(
            repository: repository
        )
    }

    func testConvertedList() throws {
        repository.supportedCurrencies = [
            Currency(code: "AAA", name: "Aa Ab Ac"),
            Currency(code: "BBB", name: "Ba Bb Bc"),
            Currency(code: "CCC", name: "Ca Cb Cc"),
            Currency(code: "USD", name: "United States Dollar"),
        ]
        repository.conversionRates = [
            ConversionRate(before: "USD", after: "AAA", rate: 1000),
            ConversionRate(before: "USD", after: "BBB", rate: 200),
            ConversionRate(before: "USD", after: "CCC", rate: 50),
            ConversionRate(before: "USD", after: "USD", rate: 1),
        ]

        store.load()
        store.selectCurrency(currency: Currency(code: "BBB", name: "Ba Bb Bc"))
        store.setAmount(amount: 100)

        store.convertedList.drive(onNext: { convertedList in
            XCTAssertEqual(4, convertedList.count)

            XCTAssertEqual("AAA", convertedList[0].currency.code)
            XCTAssertEqual("BBB", convertedList[1].currency.code)
            XCTAssertEqual("CCC", convertedList[2].currency.code)
            XCTAssertEqual("USD", convertedList[3].currency.code)

            XCTAssertEqual(500, convertedList[0].amount)
            XCTAssertEqual(100, convertedList[1].amount)
            XCTAssertEqual(25, convertedList[2].amount)
            XCTAssertEqual(0.5, convertedList[3].amount)
        }).disposed(by: disposeBag)
    }
}
