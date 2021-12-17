import UIKit
import Firebase
import FirebaseDatabase
import CodableFirebase

class ContentModel: Codable {
    var name: String
    var category: String
    var interval: Int
    var lastDate: String
    var index: Int
    
    init(name:String, category:String, interval:Int, lastDate:String, index:Int){
        self.name = name
        self.category = category
        self.interval = interval
        self.lastDate = lastDate
        self.index = index
    }
    
    func updateInterval(withInt: Int, idKey:String = "careTakerID") {
        let id = UserDefaults.standard.string(forKey: idKey)!
        self.interval = withInt
        let DBRef = Database.database().reference()
        let data = try? FirebaseEncoder().encode(self)
        DBRef.child("users/\(id)/\(index)").setValue(data)
    }
    
    func updateLastDate(withText: String, idKey:String = "careTakerID") {
        let id = UserDefaults.standard.string(forKey: idKey)!
        self.lastDate = withText
        let DBRef = Database.database().reference()
        let data = try? FirebaseEncoder().encode(self)
        DBRef.child("users/\(id)/\(index)").setValue(data)
        
    }
    
}
