import UIKit
// CollectionViewHeaderの設定
class CollectionViewHeader: UICollectionReusableView {
  override init(frame: CGRect) {
    super.init(frame: frame)
    setUpViews()
  }
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  // titleLabelの生成、書式設定
  var titleLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 30, weight: UIFont.Weight(rawValue: 10))
    label.textColor = UIColor.white
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  // headerのsetup内容
  func setUpViews() {
    // headerの背景色
    backgroundColor = UIColor.systemGray2
    // headerにtitleLabelを追加
    addSubview(titleLabel)
    // headerに対するtitleLabelの配置
    titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
    titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
    titleLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1).isActive = true
    titleLabel.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 1).isActive = true
  }
  // titleLabelのtextを設定
  func setUpContents(titleText: String) {
    titleLabel.text = titleText
  }
}
