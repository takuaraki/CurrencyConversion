//
//  CurrencyDBTestCase.swift
//  CurrencyConversionTests
//
//  Created by ArakiTaku on 2021/01/18.
//

@testable import CurrencyConversion
import XCTest

class CurrencyDBTestCase: XCTestCase {
    var db: CurrencyDB!

    lazy var testData = [conversionRateA, conversionRateB]
    let conversionRateA = ConversionRate(before: "USD", after: "AAA", rate: 100)
    let conversionRateB = ConversionRate(before: "USD", after: "BBB", rate: 50)

    override func setUpWithError() throws {
        db = CurrencyDB()
    }

    override func tearDownWithError() throws {
        let appDomain = Bundle.main.bundleIdentifier
        UserDefaults.standard.removePersistentDomain(forName: appDomain!)
    }

    func testLoadInCacheTime() throws {
        db.saveConversionRates(conversionRates: testData, currentDate: Date())
        let loaded = db.loadConversionRates(currentDate: Date())
        XCTAssertEqual(testData, loaded)
    }

    func testLoadOutOfCacheTime() throws {
        db.saveConversionRates(conversionRates: testData, currentDate: Date())
        var date = Date()
        date.addTimeInterval(30 * 60 + 1)
        let loaded = db.loadConversionRates(currentDate: date)
        XCTAssertNil(loaded)
    }
}
