import FirebaseDatabase
import CodableFirebase

class UpdateFirebase {
    
    var section: Int
    var row: Int
    
    init(section: Int, row: Int) {
        self.section = section
        self.row = row
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
    
}
