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
    var contents = [[ContentModel]]()
    let DBRef = Database.database().reference()
    var idKey: String
    
    init(idKey:String = "careTakerID") {
        self.idKey = idKey
    }
    
    func configuration(progress: @escaping (ContentsListModelState) -> Void) {

        let id = UserDefaults.standard.string(forKey: idKey)
        if id == nil  {
            generateNewUser(idKey: idKey) {
                state in
                if state == .finish {
                    let newid = UserDefaults.standard.string(forKey: self.idKey)
                    self.pullData(userId: newid!, progress: progress)
                }
            }
        } else {
            self.pullData(userId: id!, progress: progress)
        }
    }
    
    func generateNewUser(idKey: String, progress: @escaping (ContentsListModelState) -> Void) {
        progress(.loading)
        DBRef.child("temp").getData() {
            error,snap in
            
            guard let arrayOfArray = snap.value as? [[[String:Any]]] else {
                progress(.error)
                return
            }
            for arrOfDict in arrayOfArray {
                var rowArray = [ContentModel]()
                arrOfDict.forEach {
                    dict in
                    
                    guard let content = try? FirebaseDecoder().decode(ContentModel.self, from: dict) else {
                        progress(.error)
                        print("-----Decode error-----")
                        return
                    }
                    rowArray.append(content)
                }
                self.contents.append(rowArray)
            }
            let id = self.DBRef.child("users").childByAutoId()
            let data = try? FirebaseEncoder().encode(self.contents)
            id.setValue(data)
            UserDefaults.standard.set(id.key, forKey: idKey)
            print("----generate----")
            progress(.finish)
        }
    }
    
    func pullData(userId: String, progress: @escaping (ContentsListModelState) -> Void) {
        print("--- pull from firebase, user id=\(userId)")
        contents.removeAll()
        progress(.loading)
        DBRef.child("users/\(userId)").getData() {
            error, snap in
            
            guard let arrayOfArray = snap.value as? [[[String:Any]]] else {
                progress(.error)
                print("----cast error----")
                return
            }
            for arrOfDict in arrayOfArray {
                var rowArray = [ContentModel]()

                for dict in arrOfDict {
                    guard var content = try? FirebaseDecoder().decode(ContentModel.self, from: dict) else {
                        progress(.error)
                        print("-----Decode error-----")
                        return
                    }
                    if content.id == nil {
                        content.id = UUID().uuidString
                        let updater = FirebaseContentRepository.Updater(section: content.section, row: content.row)
                        updater.updateId(itemId: content.id!)
                    }
                    rowArray.append(content)
                }
                self.contents.append(rowArray)
            }
            progress(.finish)
            print("----pullData----")
        }
    }    
}
