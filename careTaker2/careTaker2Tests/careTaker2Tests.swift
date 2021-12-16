//
//  careTaker2Tests.swift
//  careTaker2Tests
//
//  Created by Yuki Iwama on 2021/12/15.
//

import XCTest
@testable import careTaker2
import Firebase
import FirebaseDatabase

class careTaker2Tests: XCTestCase {
    var DBRef:DatabaseReference = Database.database().reference()
    var id:String?
    var model:ContentsListModel!
    
    
    override func setUp() {
        let expectation: XCTestExpectation? = self.expectation(description: "sample")
        model = ContentsListModel(idKey: "testID"){ [weak self] state in
           switch state {
           case .loading:
               print("----loading----")
           case .finish:
               XCTAssertEqual(self?.model.contents[0].name, "hair", "デフォルト値で生成される")
               XCTAssertEqual(self?.model.contents[0].lastDate, "2021-12-01", "デフォルト値で生成される")
               self?.id = UserDefaults.standard.string(forKey: "testID")
               print("####setup####")
               expectation?.fulfill()
           case .error:
               XCTFail("test失敗")
               expectation?.fulfill()
           }
        }
        self.waitForExpectations(timeout: 1, handler: nil)
    }
    
    override func tearDown() {
        //DBに保存されたデータを消す
        
        //UserDefaultsのIDを消す
        UserDefaults.standard.removeObject(forKey: "testID")
    }
    
    
    func testPullData() throws {
        print("####teststart####")
        guard let id = self.id else {
            XCTFail("UseDefaultsにIDがなかったら失敗")
            return
        }

        let expectation: XCTestExpectation? = self.expectation(description: "sample")
        self.DBRef.child("users/\(id)/0/lastDate").setValue("2021-12-30")
        model = ContentsListModel(idKey: "testID"){ [weak self] state in
           switch state {
           case .loading:
               print("----loading----")
           case .finish:
               XCTAssertEqual(self?.model.contents[0].lastDate, "2021-12-30", "変更が反映される")
               expectation?.fulfill()
           case .error:
               XCTFail("test失敗")
               expectation?.fulfill()
           }
        }
        self.waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testUpdateInterval() throws {
        let expectation: XCTestExpectation? = self.expectation(description: "sample")
        guard let id = self.id else {
            XCTFail("UseDefaultsにIDがなかったら失敗")
            return
        }
        model.contents[0].updateInterval(withInt: 100, index: 0, idKey:"testID")
        let interval = model.contents[0].interval
        XCTAssertEqual(interval, 100, "変更が反映されている")
        self.DBRef.child("users/\(id)/0/interval").getData(completion: { error, data in
            XCTAssertEqual(data.value as? Int, 100, "変更が反映されている")
            expectation?.fulfill()
        })
        self.waitForExpectations(timeout: 0.5, handler: nil)
    }
    
    func testUpdateLastDate() throws {
        let expectation: XCTestExpectation? = self.expectation(description: "sample")
        guard let id = self.id else {
            XCTFail("UseDefaultsにIDがなかったら失敗")
            return
        }
        model.contents[0].updateLastDate(withText: "2021-11-30", index: 0, idKey: "testID")
        let lastDate = model.contents[0].lastDate
        XCTAssertEqual(lastDate, "2021-11-30", "変更が反映されている")
        self.DBRef.child("users/\(id)/0/lastDate").getData(completion: { error, data in
            XCTAssertEqual(data.value as? String, "2021-11-30", "変更が反映されている")
            expectation?.fulfill()
        })
        self.waitForExpectations(timeout: 0.5, handler: nil)
    }
}
