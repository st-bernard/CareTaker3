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
    let firebaseRepository = FirebaseContentRepository()
    let startTime = ProcessInfo.processInfo.systemUptime
    
    override func viewDidLoad() {

        // Cell Size
        flowLayout.estimatedItemSize = CGSize(width: myCollectionView.frame.width / 2.2, height:myCollectionView.frame.width / 4)
        myCollectionView.delegate = self
        myCollectionView.dataSource = self
    }
    
    private func reload() {
        let indexSet = NSMutableIndexSet()
        for i in 0..<myCollectionView.numberOfSections {
            indexSet.add(i)
        }
        firebaseRepository.reloadFirebaseData{
            success,newModel in
            if success {
                self.model = newModel
                let dat = self.model.contents.flatMap{ $0 }.filter{ $0.isActive }
                self.activeModel = Dictionary(grouping: dat, by: { $0.section })
                for key in self.activeModel.keys {
                    self.activeModel[key]?.sort(by: {
                        (item0, item1) in
                        return item0.row < item1.row
                    })
                }
                self.activeModelSortedKeys = self.activeModel.keys.map{ Int($0) }
                self.activeModelSortedKeys.sort()
                self.myCollectionView.reloadData()
                
                PushNotification.registerLocalPush(model: self.model)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {

        reload()
    }
    
    // [2] セクションの数を教えてあげる
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return activeModel.count
    }
    
    // [3] 各セクションのデータの数を教えてあげる
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard activeModel.count != 0 else{ return 0 }
        let count = activeModel[activeModelSortedKeys[section]]?.count ?? -1
        return count
    }
    
    // [4] ヘッダーに、活きた値を注入する
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let collectionViewHeader = myCollectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "Header", for: indexPath) as? MyHeader else {
            fatalError()
        }
        if kind == UICollectionView.elementKindSectionHeader {
            let headerText = activeModel[activeModelSortedKeys[indexPath.section]]?[0].category ?? "n/a"
            collectionViewHeader.setTitle(str: "\(headerText)")
            return collectionViewHeader
        }
        return UICollectionReusableView()
        
    }
    
    // [5] セルに、活きた値を注入する
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = myCollectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! MyMeterCell
        let newModel = activeModel[activeModelSortedKeys[indexPath.section]]?[indexPath.row]
        guard let newModel = newModel else {
            fatalError()
        }
        cell.isFadein = (ProcessInfo.processInfo.systemUptime - startTime) < 5.0
        cell.setValue(model: newModel)
        return cell
    }
    
    // セグエで移動直前にコールする(ReactのPropsみたいな）
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueMainToDetail", let vc = segue.destination as? SettingViewController {
            vc.contentsList = Dictionary(grouping: self.model.contents.flatMap{ $0 }, by: { $0.section })

            let cn = vc.contentsList.values.flatMap{ $0 }.map{ $0.category }
            vc.categoryNames = Array(Set(cn))
        }
        if segue.identifier == "segueMainToContents", let vc = segue.destination as? MyDetailView {
            if let selectedModel = selectedModel {
                vc.content = selectedModel
            } else {
                debugPrint("セグエ発火したけど、selectedModelが設定されていなかったので無視しました")
            }
        }

        if segue.identifier == "segueMainToAbout", let vc = segue.destination as? AboutViewController {
            vc.model = model
            vc.testTapped = {
                self.reload()
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
    
    
    @IBAction func demoButton(_ sender: Any) {
        
        let demoTime = Calendar.current.date(byAdding: .second, value: 10, to: Date())!
        var nextDueDateTime = DateComponents()
        nextDueDateTime.year = DateUtils.getDateTimePart(demoTime, part: .year4)
        nextDueDateTime.month = DateUtils.getDateTimePart(demoTime, part: .month)
        nextDueDateTime.day = DateUtils.getDateTimePart(demoTime, part: .day)
        nextDueDateTime.hour = DateUtils.getDateTimePart(demoTime, part: .hour24)
        nextDueDateTime.minute = DateUtils.getDateTimePart(demoTime, part: .minute)
        nextDueDateTime.second = DateUtils.getDateTimePart(demoTime, part: .second)
        PushNotification.pushLocal(id: UUID().uuidString, title: "CareTakerからのお知らせ", body: "「トイレットペーパー」の期限です。", at: nextDueDateTime)
    }
}

