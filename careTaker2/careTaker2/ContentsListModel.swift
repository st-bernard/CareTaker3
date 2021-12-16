import Foundation
import Firebase
import FirebaseDatabase
import CodableFirebase

enum ContentsListModelState {
    case loading
    case finish
    case error
}

typealias ResultHandler<T> = (Result<T, Error>) -> Void

class ContentsListModel {
    var contents = [ContentModel]()
    let DBRef = Database.database().reference()
    
    init(progress: @escaping (ContentsListModelState) -> Void){
        if let careTakerID = UserDefaults.standard.string(forKey: "careTakerID") {
            self.pullData(careTakerID: careTakerID, progress: progress)
        } else {
            self.generateNewUser(progress: progress)
        }
    }
    
    func generateNewUser(progress: @escaping (ContentsListModelState) -> Void) {
        progress(.loading)
        DBRef.child("temp").getData(){ error,snap in
            guard let arrayofDicts = snap.value as? [[String:Any]] else {
                progress(.error)
                return
            }
            arrayofDicts.forEach {dict in
                guard let content = try? FirebaseDecoder().decode(ContentModel.self, from: dict) else {
                    progress(.error)
                    print("-----Decode error-----")
                    return
                }
                self.contents.append(content)
            }
            let id = self.DBRef.child("users").childByAutoId()
            let data = try? FirebaseEncoder().encode(self.contents)
            id.setValue(data)
//            UserDefaults.standard.set(id.key, forKey: "careTakerID")
            progress(.finish)
            print("----generate----")
        }
    }
    
    func pullData(careTakerID: String, progress: @escaping (ContentsListModelState) -> Void) {
        
    }
    
    func updateInterval() {
        
    }
    
    func updateLastDate() {
        
    }
    
}
