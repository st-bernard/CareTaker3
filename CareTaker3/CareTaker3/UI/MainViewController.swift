//
//  MainViewController.swift
//  CareTaker3
//
//  Created by Tasuku Furuki on 2021/12/24.
//

import UIKit

class MainViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var myCollectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    var model: ContentsListModel!
    var activeModel = [[ContentModel]]()
    
    override func viewDidLoad() {
        
        // Cell Size
        flowLayout.estimatedItemSize = CGSize(width: myCollectionView.frame.width / 2.2, height:myCollectionView.frame.width / 4)
        
        //        TODO: [1]
        myCollectionView.delegate = self
        myCollectionView.dataSource = self
        
        model = ContentsListModel()
        model.configuration(){ [weak self] state in
            switch state {
            case .loading:
                print("----loading----")
            case .finish:
                print("----finished----")
                self?.activeModel.removeAll()
                self?.model.contents.forEach({arrOfContents in
                    let array = arrOfContents.filter({content in
                        content.isActive == true
                    })
                    guard array.count != 0 else { return }
                    self?.activeModel.append(array)
                })
                DispatchQueue.main.async {
                    self?.myCollectionView.reloadData()
                }
            case .error:
                print("----error----")
            }
        }
        
    }
    //    TODO: [2] セクションの数を教えてあげる
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return activeModel.count
    }
    
    //TODO: [3] 各セクションのデータの数を教えてあげる
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard activeModel.count != 0 else{ return 0}
        return activeModel[section].count
    }
    
//    TODO: [4] ヘッダーに、活きた値を注入する
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let collectionViewHeader = myCollectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "Header", for: indexPath) as? MyHeader else {
            fatalError()
        }
        if kind == UICollectionView.elementKindSectionHeader {
            let headerText = activeModel[indexPath.section][indexPath.row].category
            collectionViewHeader.setTitle(str: headerText)
            return collectionViewHeader
        }
        return UICollectionReusableView()
        
    }
    
//    TODO: [5] セルに、活きた値を注入する
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = myCollectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! MyMeterCell
        let d = activeModel[indexPath.section][indexPath.row]

        cell.setValue(model: d)
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueMainToDetail", let vc = segue.destination as? SettingViewController {
            vc.contentsList = activeModel
            
            vc.categoryNames = vc.contentsList.map({section in
                return section[0].category
            })
        }
    }
}
