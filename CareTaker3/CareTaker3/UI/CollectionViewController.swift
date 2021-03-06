import UIKit

class CollectionViewController: UIViewController {
    var model: ContentsListModel!
    
    var collectionView: UICollectionView!
    var activeModel = [[ContentModel]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "CareTaker"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "questionmark.circle"), style: .plain, target: self, action: #selector(didTapHelpButton(_:)))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(didTapEditButton(_:)))
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height), collectionViewLayout: UICollectionViewFlowLayout())
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
                    self?.collectionView.reloadData()
                }
            case .error:
                print("----error----")
            }
        }
        
        // UICollectionViewを生成、書式設定
        collectionView.backgroundColor = .white
        // CVCell classを"Cell"という名前でCVに登録
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        // CVHeader classを"Header"という名前でCVのheaderとして登録
        collectionView.register(CollectionViewHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "Header")
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        view.addSubview(collectionView)
    
    }
    
    @objc func didTapHelpButton(_ sender: UIBarButtonItem) {
        let VC = TutorialViewController()
        let navVC = UINavigationController(rootViewController: VC)
        navVC.modalPresentationStyle = .formSheet
        present(navVC, animated: true, completion: nil)
    }

    @objc func didTapEditButton(_ sender: UIBarButtonItem) {
////        let settingVC = SettingViewController(contentsList: model.contents, delegate: self)
//        let navVC = UINavigationController(rootViewController: settingVC)
//        present(navVC, animated: true)
    }
}

// UICVDelegateを追加
extension CollectionViewController: UICollectionViewDelegate {
    // セル選択時の処理
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let contentView = ContentsViewController(
//            content: activeModel[indexPath.section][indexPath.row],
//            delegate: self
//        )
//        let navVC = UINavigationController(rootViewController: contentView)
//        present(navVC, animated: true)
    }
}

//extension CollectionViewController: ReceiverDelegate{
//    func reloadView(){
//        self.viewDidLoad()
//    }
//}
  
//　UICVDataSourceを追加
extension CollectionViewController: UICollectionViewDataSource {
    // 各section内におけるcellの数を返す
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard activeModel.count != 0 else{ return 0}
        return activeModel[section].count
    }
    
    // sectionの数
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return activeModel.count
    }
    
    // cellの設定
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // cellを生成
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionViewCell
        cell.titleLabel.text = activeModel[indexPath.section][indexPath.row].name
        let RGBV = CGFloat(
            intervalRateData(
                lastDate: activeModel[indexPath.section][indexPath.row].lastDate,
                interval: activeModel[indexPath.section][indexPath.row].interval
            )
        )
        cell.backgroundColor = UIColor(red: 255/255, green: RGBV/255, blue: RGBV/255, alpha: 1.0)
        return cell
    }
    
    private func intervalRateData(lastDate: String, interval: Int) -> Int{
        //Now date
        let now = Date()
        //lastdate
        let lastDateCalc = DateUtils.dateFromString(string: lastDate+" 00:00:00 +00:00", format: "yyyy年MM月dd日 HH:mm:ss Z")
        //nowdate - lastdateƒ
        guard let elapsedDays = Calendar.current.dateComponents([.day], from: lastDateCalc, to: now).day else {return 0}
        //interval(Float)
        let convertInterval:Float = Float(interval)
        let convertElapsed:Float = Float(elapsedDays)
        let rateDate = convertElapsed / (convertInterval)
        let RGBValue:Int = Int(255 * (1 - rateDate))
        return RGBValue
    }
    // headerの設定
        func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
            // headerを生成
            let collectionViewHeader = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "Header", for: indexPath) as! CollectionViewHeader
            let headerText = activeModel[indexPath.section][indexPath.row].category
            // headerのtitleLabelにtextを追加
            collectionViewHeader.setUpContents(titleText: headerText)
            return collectionViewHeader
        }
}

extension CollectionViewController:  UICollectionViewDelegateFlowLayout {
    // cellのサイズを設定
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 160, height: 50)
    }
    
    // cellの余白
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    }
    
    // headerのサイズ
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: self.view.frame.size.width, height:50)
    }

}




