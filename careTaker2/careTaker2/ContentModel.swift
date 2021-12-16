import UIKit
import Firebase
import FirebaseDatabase
import CodableFirebase

class ContentModel: Codable {
    var name: String
    var category: String
    var interval: Int
    var lastDate: String
    
    init(name:String, category:String, interval:Int, lastDate:String){
        self.name = name
        self.category = category
        self.interval = interval
        self.lastDate = lastDate
    }
    
    func updateInterval(withInt: Int, index:Int) {
        let id = UserDefaults.standard.string(forKey: "careTakerID")!
        self.interval = withInt
        let DBRef = Database.database().reference()
        let data = try? FirebaseEncoder().encode(self)
        DBRef.child("users/\(id)/\(index)").setValue(data)
    }
    
    func updateLastDate(withText: String, index:Int) {
        let id = UserDefaults.standard.string(forKey: "careTakerID")!
        self.lastDate = withText
        let DBRef = Database.database().reference()
        let data = try? FirebaseEncoder().encode(self)
        DBRef.child("users/\(id)/\(index)").setValue(data)
        
    }
    
}
