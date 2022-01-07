//
//  FirebaseContentRepository.swift
//  CareTaker3
//
//  Created by kai on 2022/01/05.
//

import Foundation
import FirebaseDatabase
import CodableFirebase

class FirebaseContentRepository {
    
    class Updater {
        
        var section: Int
        var row: Int
        
        init(section: Int, row: Int) {
            self.section = section
            self.row = row
        }
        
        func updateId(itemId: String, idKey: String = "careTakerID") {
            let id = UserDefaults.standard.string(forKey: idKey)!
            let DBRef = Database.database().reference()
            DBRef.child("users/\(id)/\(section)/\(row)/id").setValue(itemId)
        }

        func updateLocation(isHome: Bool, idKey:String = "careTakerID") {

            let id = UserDefaults.standard.string(forKey: idKey)!
            let DBRef = Database.database().reference()
            DBRef.child("users/\(id)/\(section)/\(row)/isHome").setValue(isHome)
        }

        
        func updateLocation(isHome: Bool, locationName: String, lon: Double, lat: Double, idKey:String = "careTakerID") {

            let id = UserDefaults.standard.string(forKey: idKey)!
            let DBRef = Database.database().reference()
            DBRef.child("users/\(id)/\(section)/\(row)/isHome").setValue(isHome)
            DBRef.child("users/\(id)/\(section)/\(row)/locationName").setValue(locationName)
            DBRef.child("users/\(id)/\(section)/\(row)/locationLon").setValue(lon)
            DBRef.child("users/\(id)/\(section)/\(row)/locationLat").setValue(lat)
        }
        
        func updateInterval(withInt: Int, idKey:String = "careTakerID") {
            let id = UserDefaults.standard.string(forKey: idKey)!
            let DBRef = Database.database().reference()
            DBRef.child("users/\(id)/\(section)/\(row)/interval").setValue(withInt)
        }

        func updateLastDate(withText: String, idKey:String = "careTakerID") {
            let id = UserDefaults.standard.string(forKey: idKey)!
            let DBRef = Database.database().reference()
            DBRef.child("users/\(id)/\(section)/\(row)/lastDate").setValue(withText)
            
        }
        
        func updateIsActive(isActive: Bool, idKey:String = "careTakerID") {
            let id = UserDefaults.standard.string(forKey: idKey)!
            let DBRef = Database.database().reference()
            DBRef.child("users/\(id)/\(section)/\(row)/isActive").setValue(isActive)
        }
        
    }
    
    func reloadFirebaseData(callback: @escaping (Bool, ContentsListModel) -> Void ) {
        
        let model = ContentsListModel()
        model.configuration(){
            state in
            switch state {
            case .loading:
                print("----loading----")
            case .finish:
                print("----finished----")
                callback(true, model)
            case .error:
                print("----error----")
                callback(false, model)
            }
        }
    }
}
