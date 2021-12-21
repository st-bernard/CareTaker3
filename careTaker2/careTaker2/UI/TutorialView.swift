import UIKit

class TutorialView{
    lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        return view
    }()
    // 2
    lazy var dimmedView: UIView = {
        let view = UIView()
        return view
    }()
    let defaultHeight: CGFloat = 600
    // 3. Dynamic container constraint
    var containerViewHeightConstraint: NSLayoutConstraint?
    var containerViewBottomConstraint: NSLayoutConstraint?
    
    let tutorialGif: UIImageView = {
        let gif = UIImageView()
        gif.layer.borderWidth = 2
        gif.layer.borderColor = UIColor.systemGray.cgColor
        gif.loadGif(asset: "Sample")
        return gif
    }()
    let title: UILabel = {
        let label = UILabel()
        label.text = "チュートリアル"
        label.textColor = .black
        label.font = .systemFont(ofSize: 20, weight: UIFont.Weight(rawValue: 10))
        label.textAlignment = .center
        return label
    }()
    let explanation: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "・赤に近い色ほど期日が迫っています"+"\n\n"+"・セルをタップすると詳細な情報に\nアクセスできます"
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    let dismissbutton: UIButton = {
        let button = UIButton()
        button.tintColor = .systemGray
        button.setTitleColor(.systemBlue, for: .normal)
        button.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        return button
    }()
}
