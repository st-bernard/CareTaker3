import UIKit

class CollectionViewController: UIViewController {
    var model: ContentsListModel!

    let arr = [["かみ","ひげ"],["掃除","紙"]]
    let categoryIndex = [[0,1],[2,3]]
    let categories = ["人間","トイレ"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("----\(#function)----")
        model = ContentsListModel{ [weak self] state in
            switch state {
            case .loading:
                print("----loading----")
            case .finish:
                dump(self?.model.contents)
                print("----finished----")
//                let modelTemp = self?.model.contents.map{$0.category}
//                dump(modelTemp)
//                let modelCategory:Set = Set(modelTemp!)
//                dump(modelCategory)
//                let counter = NSCountedSet(array : modelTemp!)
//                let counts = modelCategory.map { ($0, counter.count(for: $0)) }
//                print("count:")
//                dump(counts[0].1)
//                let modelName = self?.model.contents.map{$0.name}
//                dump(modelName)
            case .error:
                print("----error----")
            }
        }
        // UICollectionViewを生成、書式設定
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width * 3, height: view.frame.size.height), collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor = .white
        // CVCell classを"Cell"という名前でCVに登録
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        // CVHeader classを"Header"という名前でCVのheaderとして登録
        collectionView.register(CollectionViewHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "Header")
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        view.addSubview(collectionView)
    }
}

// UICVDelegateを追加
extension CollectionViewController: UICollectionViewDelegate {
    // セル選択時の処理
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("######タップした時の関数",#function)
        let contentView = ContentsViewController(content: self.model.contents[categoryIndex[indexPath.section][indexPath.row]])
        present(contentView, animated: true)
    }
}
  
//　UICVDataSourceを追加
extension CollectionViewController: UICollectionViewDataSource {
    // 各section内におけるcellの数を返す
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arr[section].count
    }
    
    // sectionの数
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return arr.count
    }
    
    // cellの設定
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // cellを生成
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionViewCell
        cell.titleLabel.text = arr[indexPath.section][indexPath.row]
        cell.backgroundColor = .white
        return cell
    }
    
    // headerの設定
        func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
            // headerを生成
            let collectionViewHeader = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "Header", for: indexPath) as! CollectionViewHeader
            let headerText = categories[indexPath.section]
            // headerのtitleLabelにtextを追加
            collectionViewHeader.setUpContents(titleText: headerText)
            return collectionViewHeader
        }
}

extension CollectionViewController:  UICollectionViewDelegateFlowLayout {
    // cellのサイズを設定
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: 150)
    }
    
    // cellの余白
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    // headerのサイズ
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: self.view.frame.size.width, height:50)
    }
    
//    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//
//        if let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SectionHeader", for: indexPath) as? CollectionViewHeader{
//            sectionHeader.titleLabel.text = "Section \(indexPath.section)"
//            return sectionHeader
//        }
//        return UICollectionReusableView()
//    }
}




