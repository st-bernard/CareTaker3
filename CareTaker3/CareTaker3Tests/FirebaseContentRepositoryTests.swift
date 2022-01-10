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

class FirebaseContentRepositoryTests: XCTestCase {
    var DBRef:DatabaseReference = Database.database().reference()
    var id:String?
    var model:ContentsListModel!
    
    
    override func setUp() {
        let expectation: XCTestExpectation? = self.expectation(description: "sample")
        model = ContentsListModel(idKey: "testID")
        model.configuration() { [weak self] state in
           switch state {
           case .loading:
               print("----loading----")
           case .finish:
               XCTAssertEqual(self?.model.contents[0][0].name, "髪の毛", "デフォルト値で生成される")
               XCTAssertEqual(self?.model.contents[0][0].lastDate, "2021年12月01日", "デフォルト値で生成される")
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
        guard let id = self.id else {
            XCTFail("UseDefaultsにIDがなかったら失敗")
            return
        }
        //DBに保存されたデータを消す
        self.DBRef.child("users/\(id)").removeValue()
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
        self.DBRef.child("users/\(id)/0/0/lastDate").setValue("2021年12月30日")
        model = ContentsListModel(idKey: "testID")
        model.configuration() { [weak self] state in
           switch state {
           case .loading:
               print("----loading----")
           case .finish:
               XCTAssertEqual(self?.model.contents[0][0].lastDate, "2021年12月30日", "変更が反映される")
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
        let updateFirebase = FirebaseContentRepository.Updater(section: 0, row: 0)
        updateFirebase.updateInterval(withInt: 100, idKey:"testID")
        self.DBRef.child("users/\(id)/0/0/interval").getData(completion: { error, data in
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
        let updateFirebase = FirebaseContentRepository.Updater(section: 0, row: 0)
        updateFirebase.updateLastDate(withText: "2021年11月30日", idKey: "testID")
        self.DBRef.child("users/\(id)/0/0/lastDate").getData(completion: { error, data in
            XCTAssertEqual(data.value as? String, "2021年11月30日", "変更が反映されている")
            expectation?.fulfill()
        })
        self.waitForExpectations(timeout: 0.5, handler: nil)
    }
}
