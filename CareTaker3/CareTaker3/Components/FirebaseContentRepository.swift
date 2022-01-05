//
//  FirebaseContentRepository.swift
//  CareTaker3
//
//  Created by kai on 2022/01/05.
//

import Foundation

class FirebaseContentRepository {
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
