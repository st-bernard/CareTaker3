//
//  MainViewController.swift
//  CareTaker3
//
//  Created by Tasuku Furuki on 2021/12/24.
//

import UIKit

class MainViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    @IBOutlet weak var myCollectionView: UICollectionView!
    
    var mySections = ["身の回り", "冷蔵庫"]
    var myMinomawari = ["髪","鼻毛","髭"]
    var myReizouko = ["牛乳","卵","なっとう","鹿肉"]
    
    override func viewDidLoad() {
        //        TODO: [1]
        myCollectionView.delegate = self
        myCollectionView.dataSource = self
        
    }
    //    TODO: [2] セクションの数を教えてあげる
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return mySections.count
    }
    
    //TODO: [3] 各セクションのデータの数を教えてあげる
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
            case 0: return myMinomawari.count
            case 1: return myReizouko.count
            default: return 0
        }
    }
    
//    TODO: [4] ヘッダーに、活きた値を注入する
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = myCollectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "Header", for: indexPath) as? MyHeader else {
            fatalError()
        }
        if kind == UICollectionView.elementKindSectionHeader {
            header.setTitle(str: mySections[indexPath.section])
            return header
        }
        return UICollectionReusableView()
    }
    
//    TODO: [5] セルに、活きた値を注入する
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = myCollectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! MyMeterCell
        let d = ContentModel(nameofTASU: "T", categoryofTASU: "T", intervalofTASU: 0, LastDateofTASU: "T", sectionofTASU: 0, rowofTASU: 0, isActiveofTASU: true)
        switch indexPath.section {
        case 0:
            d.name = myMinomawari[indexPath.row]
        case 1:
            d.name = myReizouko[indexPath.row]
        default:
            d.name = "ERROR"
        }
        cell.setValue(model: d)
        return cell
    }
    
}
