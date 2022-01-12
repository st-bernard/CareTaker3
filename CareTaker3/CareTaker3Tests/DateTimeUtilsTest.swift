//
//  careTaker2Tests.swift
//  careTaker2Tests
//
//  Created by Yuki Iwama on 2021/12/15.
//

import XCTest
@testable import CareTaker3

class DateTimeUtilsTest: XCTestCase {
    
    override func setUp() {
    }
    
    override func tearDown() {
    }
    
    func test_makeString() throws {

        var dc = DateComponents()
        dc.year = 2001
        dc.month = 1
        dc.day = 1
        dc.timeZone = TimeZone(abbreviation: "UTC")
        dc.hour = 1
        dc.minute = 1
        dc.second = 1
        let ret = DateUtils.makeString(dc)
        XCTAssertEqual(ret, "2001/1/1 1:01:01")
    }
    
    func test_dateFromString_and_getDateTimePart() {
        let ret = DateUtils.dateFromString(string: "2021年12月28日 13:34:45 +09:00", format: "yyyy年MM月dd日 HH:mm:ss Z")
        XCTAssertEqual(2021, DateUtils.getDateTimePart(ret, part: .year4))
        XCTAssertEqual(12, DateUtils.getDateTimePart(ret, part: .month))
        XCTAssertEqual(28, DateUtils.getDateTimePart(ret, part: .day))
        XCTAssertEqual(13, DateUtils.getDateTimePart(ret, part: .hour24))
        XCTAssertEqual(34, DateUtils.getDateTimePart(ret, part: .minute))
        XCTAssertEqual(45, DateUtils.getDateTimePart(ret, part: .second))
    }
    
    func test_string_from_date() {
        let d = Date(timeIntervalSinceReferenceDate: 3600 + 60 + 1) // 2001-01-01 01:01:01 +0000
        let ret = DateUtils.stringFromDate(date: d, format: "y-M-d H:m:s")
        XCTAssertEqual("2001-1-1 10:1:1", ret)  // NOTE: converted from UTC to JST automatically
    }
    
    func test_makeDoneDateText() {
        let date = DateUtils.dateFromString(string: "2021年09月28日", format: "yyyy年MM月dd日")
        XCTAssertEqual("2021年09月28日", DateUtils.makeDoneDateText(offsetDays: 0, from: date))
        XCTAssertEqual("2021年09月29日", DateUtils.makeDoneDateText(offsetDays: 1, from: date))
        XCTAssertEqual("2021年09月30日", DateUtils.makeDoneDateText(offsetDays: 2, from: date))
        XCTAssertEqual("2021年10月01日", DateUtils.makeDoneDateText(offsetDays: 3, from: date))
        XCTAssertEqual("2021年09月27日", DateUtils.makeDoneDateText(offsetDays: -1, from: date))
    }
}
