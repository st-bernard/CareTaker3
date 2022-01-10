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
        
        screenShot("1.起動直後")
        let collectionViewsQuery = app.collectionViews
        collectionViewsQuery.children(matching: .cell).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.tap()
        waitToAppear(for: app.staticTexts["labelInterval"].firstMatch)
        screenShot("2.髪の毛のメータータップ直後")
        XCTAssertEqual("2", app.textFields["textIntervalDays"].value as? String, "Intervalの値が前提通りであること")
        XCTAssertEqual("1", app.switches["switchHomeMap"].value as? String, "Mapモードであること")
        XCTAssertEqual("ＳｕｎｇｏｏｓｅＴＯＫＹＯ", app.staticTexts["labelLocationName"].label, "店名が前提通りであること")

#if false
        let calendarBadgeClockElement = app.scrollViews.otherElements.containing(.image, identifier:"calendar.badge.clock").element
        calendarBadgeClockElement.swipeUp()
        screenShot("2.1.スワイプUp")
        calendarBadgeClockElement.swipeDown()
        screenShot("2.2.スワイプDown")
#endif
        app.navigationBars["髪の毛"].buttons["CareTaker3"].tap()
        screenShot("2.3.メイン画面に戻った")

        collectionViewsQuery.children(matching: .cell).element(boundBy: 1).children(matching: .other).element.children(matching: .other).element.tap()
        waitToAppear(for: app.staticTexts["labelInterval"].firstMatch)
        screenShot("3.ひげのメータータップ直後")
        XCTAssertEqual("2", app.textFields["textIntervalDays"].value as? String, "Intervalが前提通りであること")
        XCTAssertEqual("0", app.switches["switchHomeMap"].value as? String, "Homeモードであること")
        XCTAssertFalse(app.staticTexts["labelLocationName"].exists, "店名が非表示であること")
        app.navigationBars["ひげ"].buttons["CareTaker3"].tap()
        screenShot("3.1.メイン画面に戻った")
    }
    
    func test_SenarioNo2() {
        
        let app = XCUIApplication()
        let tabBar = app.tabBars["Tab Bar"]
        tabBar.buttons["Location"].tap()
        waitToAppear(for: app.staticTexts["locationDueLabel"].firstMatch)
        screenShot("ロケーションタブ表示直後")
        //---
        let dueintervalsliderSlider = app.sliders["dueIntervalSlider"]
        dueintervalsliderSlider.adjust(toNormalizedSliderPosition: 0.25)
        dueintervalsliderSlider.adjust(toNormalizedSliderPosition: 0.75)
        dueintervalsliderSlider.adjust(toNormalizedSliderPosition: 0.01)  // 1day
        dueintervalsliderSlider/*@START_MENU_TOKEN@*/.press(forDuration: 1.5);/*[[".tap()",".press(forDuration: 1.5);"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        screenShot("期限1日")
        XCTAssertEqual("期限 \(1)日前のアクション一覧", app.staticTexts["locationDueLabel"].label, "店名が前提通りであること")
        //---
        dueintervalsliderSlider.adjust(toNormalizedSliderPosition: 0.5)   // 10day
        dueintervalsliderSlider/*@START_MENU_TOKEN@*/.press(forDuration: 1.3);/*[[".tap()",".press(forDuration: 1.3);"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        screenShot("期限10日")
        XCTAssertEqual("期限 \(10)日前のアクション一覧", app.staticTexts["locationDueLabel"].label, "店名が前提通りであること")
        //---
        dueintervalsliderSlider.adjust(toNormalizedSliderPosition: 0.2)   // 3day
        dueintervalsliderSlider/*@START_MENU_TOKEN@*/.press(forDuration: 1.6);/*[[".tap()",".press(forDuration: 1.6);"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        screenShot("期限3日")
        XCTAssertEqual("期限 \(3)日前のアクション一覧", app.staticTexts["locationDueLabel"].label, "店名が前提通りであること")
        //---
        dueintervalsliderSlider.adjust(toNormalizedSliderPosition: 0.25)  // 5day
        dueintervalsliderSlider/*@START_MENU_TOKEN@*/.press(forDuration: 1.6);/*[[".tap()",".press(forDuration: 1.6);"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        screenShot("期限5日")
        XCTAssertEqual("期限 \(5)日前のアクション一覧", app.staticTexts["locationDueLabel"].label, "店名が前提通りであること")
        
        //---
        let tablesQuery = app.tables
        let staticText = tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["ドラッグストア・スマイル　芝浦店"]/*[[".cells.staticTexts[\"ドラッグストア・スマイル　芝浦店\"]",".staticTexts[\"ドラッグストア・スマイル　芝浦店\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        staticText.tap()
        staticText/*@START_MENU_TOKEN@*/.press(forDuration: 1.2);/*[[".tap()",".press(forDuration: 1.2);"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        screenShot("ドラックストア・スマイル芝浦店 クリック")
        //---
        let cell = tablesQuery/*@START_MENU_TOKEN@*/.cells.containing(.staticText, identifier:"ＳｕｎｇｏｏｓｅＴＯＫＹＯ").element/*[[".cells.containing(.staticText, identifier:\"髪の毛\").element",".cells.containing(.staticText, identifier:\"ＳｕｎｇｏｏｓｅＴＯＫＹＯ\").element"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        cell.tap()
        cell/*@START_MENU_TOKEN@*/.press(forDuration: 1.1);/*[[".tap()",".press(forDuration: 1.1);"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        screenShot("SungooseTOKYO クリック")
        //---
        let staticText2 = tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["ケーヨーデイツー三田店"]/*[[".cells.staticTexts[\"ケーヨーデイツー三田店\"]",".staticTexts[\"ケーヨーデイツー三田店\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        staticText2.tap()
        staticText2/*@START_MENU_TOKEN@*/.press(forDuration: 1.0);/*[[".tap()",".press(forDuration: 1.0);"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        screenShot("ケーヨーデーツ三田店 クリック")
        //---
        app.tabBars["Tab Bar"].buttons["Meter"].tap()
    }
    
    func test_SenarioNo3() {
        
        let app = XCUIApplication()
        let table = app.windows.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .table).element
        let caretaker3Button = app.navigationBars["Your Choice"].buttons["CareTaker3"]
        let editButton = app.navigationBars["CareTaker3"].buttons["Edit"]
        editButton.tap()
        table/*@START_MENU_TOKEN@*/.press(forDuration: 1.1);/*[[".tap()",".press(forDuration: 1.1);"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        screenShot("Edit画面に遷移")

        let tablesQuery = app.tables
        let kitchenRow = tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["キッチン"]/*[[".cells.staticTexts[\"キッチン\"]",".staticTexts[\"キッチン\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        kitchenRow.tap()
        table/*@START_MENU_TOKEN@*/.press(forDuration: 0.7);/*[[".tap()",".press(forDuration: 0.7);"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        screenShot("キッチンを選択")

        let conroRow = tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["コンロ"]/*[[".cells.staticTexts[\"コンロ\"]",".staticTexts[\"コンロ\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        conroRow.tap()
        screenShot("コンロをOFF→ONに変更")

        let yourChoiceButton = app.navigationBars["表示項目選択"].buttons["Your Choice"]
        yourChoiceButton.tap()
        caretaker3Button.tap()
        screenShot("コンロが追加されている")
        editButton.tap()
        table/*@START_MENU_TOKEN@*/.press(forDuration: 0.6);/*[[".tap()",".press(forDuration: 0.6);"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        kitchenRow.tap()
        conroRow.tap()
        screenShot("コンロをON→OFFに変更")
        yourChoiceButton.tap()
        caretaker3Button.tap()
        screenShot("コンロが削除されている")
    }

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
