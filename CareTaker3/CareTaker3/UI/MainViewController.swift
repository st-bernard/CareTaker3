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
    var activeModel = Dictionary<Int, Array<ContentModel>>()
    var activeModelSortedKeys = Array<Int>()
    
    override func viewDidLoad() {

        // Cell Size
        flowLayout.estimatedItemSize = CGSize(width: myCollectionView.frame.width / 2.2, height:myCollectionView.frame.width / 4)
        
        //        TODO: [1]
        myCollectionView.delegate = self
        myCollectionView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        reloadFirebaseData()
    }
    
    private func reloadFirebaseData() {
        
        let indexSet = NSMutableIndexSet()
        for i in 0..<myCollectionView.numberOfSections {
            indexSet.add(i)
        }
        model = ContentsListModel()
        model.configuration(){
            [weak self] state in
            switch state {
                case .loading:
                    print("----loading----")
                case .finish:
                    print("----finished----")
                    if let me = self {
                        let dat = me.model.contents.flatMap{ $0 }.filter{ $0.isActive }
                        me.activeModel = Dictionary(grouping: dat, by: { $0.section })
                        for key in me.activeModel.keys {
                            me.activeModel[key]?.sort(by: {
                                (item0, item1) in
                                return item0.row < item1.row
                            })
                        }
                        me.activeModelSortedKeys = me.activeModel.keys.map{ Int($0) }
                        me.activeModelSortedKeys.sort()
                        me.myCollectionView.reloadData()
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
        guard activeModel.count != 0 else{ return 0 }
        let count = activeModel[activeModelSortedKeys[section]]?.count ?? -1
        return count
    }
    
    //    TODO: [4] ヘッダーに、活きた値を注入する
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let collectionViewHeader = myCollectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "Header", for: indexPath) as? MyHeader else {
            fatalError()
        }
        if kind == UICollectionView.elementKindSectionHeader {
            let headerText = activeModel[activeModelSortedKeys[indexPath.section]]?[0].category ?? "n/a"
            collectionViewHeader.setTitle(str: "\(headerText) [\(indexPath.section)(\(activeModelSortedKeys[indexPath.section]))]")
            return collectionViewHeader
        }
        return UICollectionReusableView()
        
    }
    
    //    TODO: [5] セルに、活きた値を注入する
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = myCollectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! MyMeterCell
        let newModel = activeModel[activeModelSortedKeys[indexPath.section]]?[indexPath.row]
        guard let newModel = newModel else {
            fatalError()
        }
        cell.setValue(model: newModel)
        return cell
    }
    
    // セグエで移動直前にコールする(ReactのPropsみたいな）
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueMainToDetail", let vc = segue.destination as? SettingViewController {
            vc.contentsList = activeModel
            
            let cn = vc.contentsList.values.map{ $0 as! [ContentModel] }.flatMap{ $0 }.map{ $0.category }
            vc.categoryNames = Array(Set(cn))
        }
        if segue.identifier == "segueMainToContents", let vc = segue.destination as? MyDetailView {
            if let selectedModel = selectedModel {
                vc.content = selectedModel
            } else {
                debugPrint("セグエ発火したけど、selectedModelが設定されていなかったので無視しました")
            }
        }
    }
    
    var selectedModel: ContentModel? = nil
    
    // セル選択時の処理
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let model = activeModel[activeModelSortedKeys[indexPath.section]]?[indexPath.row] {
            selectedModel = model
            performSegue(withIdentifier: "segueMainToContents", sender: self)
        }
    }
    
    // ヘッダーのサイズ
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: self.view.frame.size.width, height:16)
    }
}

