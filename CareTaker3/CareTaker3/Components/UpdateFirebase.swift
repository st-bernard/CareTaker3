import FirebaseDatabase
import CodableFirebase

class UpdateFirebase {
    
    var section: Int
    var row: Int
    
    init(section: Int, row: Int) {
        self.section = section
        self.row = row
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
