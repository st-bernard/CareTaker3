//
//  careTaker2Tests.swift
//  careTaker2Tests
//
//  Created by Yuki Iwama on 2021/12/15.
//

import XCTest
@testable import CareTaker3
import Firebase
import FirebaseDatabase

class YahooPoiClientTests: XCTestCase {
    
    override func setUp() {
    }
    
    override func tearDown() {
    }
    
    func test_GetPoi() throws {

        let taskManager: XCTestExpectation? = self.expectation(description: "gotPoi")

        let poiclient = PoiClientYahoo()
        poiclient.getPoiList(lon: 137.1556852, lat: 35.0999259, Rkm: 5.0, keyword: "理容店") {
            success, item in
            
            XCTAssertTrue(success)
            XCTAssertNotNil(item)

            taskManager?.fulfill()
        }
        
        self.waitForExpectations(timeout: 12, handler: nil)
    }
}
