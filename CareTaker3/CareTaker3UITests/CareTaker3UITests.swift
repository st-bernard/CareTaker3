//
//  CareTaker3UITests.swift
//  CareTaker3UITests
//
//  Created by Manabu Tonosaki on 2022/01/10.
//

import XCTest

class CareTaker3UITests: XCTestCase {
    
    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func screenShot(_ message: String) {
        let fullScreenShot = XCUIScreen.main.screenshot()
        let screenShot = XCTAttachment(screenshot: fullScreenShot)
        screenShot.lifetime = .keepAlways
        screenShot.name = message
        add(screenShot)
    }

    func test_SenarioNo1() throws {
        
        screenShot("起動前")
        let app = XCUIApplication()
        app.launch()
        
        // Cut1
        screenShot("1.起動直後")
        let collectionViewsQuery = app.collectionViews
        collectionViewsQuery.children(matching: .cell).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.tap()
        waitToAppear(for: app.staticTexts["labelInterval"].firstMatch)
        screenShot("2.髪の毛のメータータップ直後")
        XCTAssertEqual("2", app.textFields["textIntervalDays"].value as? String, "Intervalの値が前提通りであること")
        XCTAssertEqual("1", app.switches["switchHomeMap"].value as? String, "Mapモードであること")
        XCTAssertEqual("ＳｕｎｇｏｏｓｅＴＯＫＹＯ", app.staticTexts["labelLocationName"].label, "店名が前提通りであること")

        let calendarBadgeClockElement = app.scrollViews.otherElements.containing(.image, identifier:"calendar.badge.clock").element
        calendarBadgeClockElement.swipeUp()
        screenShot("2.1.スワイプUp")
        calendarBadgeClockElement.swipeDown()
        screenShot("2.2.スワイプDown")
        app.navigationBars["髪の毛"].buttons["CareTaker3"].tap()
        screenShot("2.3.メイン画面に戻る")

        collectionViewsQuery.children(matching: .cell).element(boundBy: 1).children(matching: .other).element.children(matching: .other).element.tap()
        waitToAppear(for: app.staticTexts["labelInterval"].firstMatch)
        screenShot("3.ひげのメータータップ直後")
        XCTAssertEqual("2", app.textFields["textIntervalDays"].value as? String, "Intervalが前提通りであること")
        XCTAssertEqual("0", app.switches["switchHomeMap"].value as? String, "Homeモードであること")
        XCTAssertFalse(app.staticTexts["labelLocationName"].exists, "店名が非表示であること")

        calendarBadgeClockElement.swipeUp()
        screenShot("3.1.スワイプUp")
        calendarBadgeClockElement.swipeDown()
        screenShot("3.2.スワイプDown")
        app.navigationBars["ひげ"].buttons["CareTaker3"].tap()
        screenShot("3.3.メイン画面に戻る")
    }
    
//    func test_SenarioNoX() throws {
//
//        let app = XCUIApplication()
//        screenShot()    // 起動直後のスクショ
//        app.tabBars["Tab Bar"].buttons["Location"].tap()
//
//        let slider = app.sliders["dueIntervalSlider"].firstMatch
//        waitToHittable(for: slider)
//        screenShot()    // Loationタブ表示直後
//    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}

extension XCTestCase {
    func waitToAppear(for element: XCUIElement,
                      timeout: TimeInterval = 5,
                      file: StaticString = #file,
                      line: UInt = #line) {
        let predicate = NSPredicate(format: "exists == true")
        let expectation = XCTNSPredicateExpectation(predicate: predicate, object: element)
        let result = XCTWaiter().wait(for: [expectation], timeout: timeout)
        XCTAssertEqual(result, .completed, file: file, line: line)
    }

    func waitToHittable(for element: XCUIElement,
                        timeout: TimeInterval = 5,
                        file: StaticString = #file,
                        line: UInt = #line) -> XCUIElement {
        let predicate = NSPredicate(format: "hittable == true")
        let expectation = XCTNSPredicateExpectation(predicate: predicate, object: element)
        let result = XCTWaiter().wait(for: [expectation], timeout: timeout)
        XCTAssertEqual(result, .completed, file: file, line: line)
        return element
    }
}
