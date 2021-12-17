import Firebase
import FirebaseDatabase
import CodableFirebase

class ContentModel: Codable {
    var name: String
    var category: String
    var interval: Int
    var lastDate: String
    var section: Int
    var row: Int
    
    func updateInterval(withInt: Int, idKey:String = "careTakerID") {
        let id = UserDefaults.standard.string(forKey: idKey)!
        self.interval = withInt
        let DBRef = Database.database().reference()
        let data = try? FirebaseEncoder().encode(self)
        DBRef.child("users/\(id)/\(section)/\(row)").setValue(data)
    }
    
    func updateLastDate(withText: String, idKey:String = "careTakerID") {
        let id = UserDefaults.standard.string(forKey: idKey)!
        self.lastDate = withText
        let DBRef = Database.database().reference()
        let data = try? FirebaseEncoder().encode(self)
        DBRef.child("users/\(id)/\(section)/\(row)").setValue(data)
        
    }
    
}
