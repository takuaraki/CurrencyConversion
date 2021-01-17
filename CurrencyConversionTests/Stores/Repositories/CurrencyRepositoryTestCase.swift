//
//  CurrencyRepositoryTestCase.swift
//  CurrencyConversionTests
//
//  Created by ArakiTaku on 2021/01/18.
//

@testable import CurrencyConversion
import XCTest
import RxSwift

class CurrencyRepositoryTestCase: XCTestCase {
    var api: CurrencyAPIMock!
    var db: CurrencyDBMock!
    var repository: CurrencyRepository!

    let disposeBag = DisposeBag()

    override func setUpWithError() throws {
        api = CurrencyAPIMock()
        db = CurrencyDBMock()
        repository = CurrencyRepository(
            api: api,
            db: db
        )
    }

    func testGetSupportedCurrencies_withNoCache() throws {
        api.supportedCurrencies = SupportedCurrenciesDTO(
            currencies: [
                "AED": "United Arab Emirates Dirham",
                "AFN": "Afghan Afghani",
            ]
        )
        db.supportedCurrencies = nil

        repository.getSupportedCurrencies().subscribe(onSuccess: { currencies in
            XCTAssertEqual(2, currencies.count)
            XCTAssertEqual(Currency(code: "AED", name: "United Arab Emirates Dirham"), currencies[0])
            XCTAssertEqual(Currency(code: "AFN", name: "Afghan Afghani"), currencies[1])
        }).disposed(by: disposeBag)
    }

    func testGetSupportedCurrencies_withCache() throws {
        api.supportedCurrencies = SupportedCurrenciesDTO(
            currencies: [
                "AED": "United Arab Emirates Dirham",
                "AFN": "Afghan Afghani",
            ]
        )
        db.supportedCurrencies = [
            Currency(code: "ALL", name: "Albanian Lek"),
            Currency(code: "AMD", name: "Armenian Dram"),
            Currency(code: "ANG", name: "Netherlands Antillean Guilder")
        ]

        repository.getSupportedCurrencies().subscribe(onSuccess: { currencies in
            XCTAssertEqual(3, currencies.count)
            XCTAssertEqual(Currency(code: "ALL", name: "Albanian Lek"), currencies[0])
            XCTAssertEqual(Currency(code: "AMD", name: "Armenian Dram"), currencies[1])
            XCTAssertEqual(Currency(code: "ANG", name: "Netherlands Antillean Guilder"), currencies[2])
        }).disposed(by: disposeBag)
    }

    func testGetConversionRates_withNoCache() throws {
        api.conversionRates = ConversionRateDTO(quotes: [
            "USDAED": 3.673042,
            "USDAFN": 77.395588,
        ])
        db.conversionRates = nil
        repository.getConversionRates().subscribe(onSuccess: { conversionRates in
            XCTAssertEqual(2, conversionRates.count)
            XCTAssertEqual(ConversionRate(before: "USD", after: "AED", rate: 3.673042), conversionRates[0])
            XCTAssertEqual(ConversionRate(before: "USD", after: "AFN", rate: 77.395588), conversionRates[1])
        }).disposed(by: disposeBag)
    }

    func testGetConversionRates_withCache() throws {
        api.conversionRates = ConversionRateDTO(quotes: [
            "USDAED": 3.673042,
            "USDAFN": 77.395588,
        ])
        db.conversionRates = [
            ConversionRate(before: "USD", after: "ALL", rate: 102.098597),
            ConversionRate(before: "USD", after: "AMD", rate: 522.530403),
            ConversionRate(before: "USD", after: "ANG", rate: 1.801565),
        ]

        repository.getConversionRates().subscribe(onSuccess: { conversionRates in
            XCTAssertEqual(3, conversionRates.count)
            XCTAssertEqual(ConversionRate(before: "USD", after: "ALL", rate: 102.098597), conversionRates[0])
            XCTAssertEqual(ConversionRate(before: "USD", after: "AMD", rate: 522.530403), conversionRates[1])
            XCTAssertEqual(ConversionRate(before: "USD", after: "ANG", rate: 1.801565), conversionRates[2])
        }).disposed(by: disposeBag)
    }
}
