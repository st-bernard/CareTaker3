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
    let maxDimmedAlpha: CGFloat = 0.5
    lazy var dimmedView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = maxDimmedAlpha
        return view
    }()
    let defaultHeight: CGFloat = 500
    // 3. Dynamic container constraint
    var containerViewHeightConstraint: NSLayoutConstraint?
    var containerViewBottomConstraint: NSLayoutConstraint?
    
    let tutorialGif: UIImageView = {
        let gif = UIImageView()
        gif.loadGif(asset: "Sample")
        return gif
    }()
    let title: UILabel = {
        let label = UILabel()
        label.text = "チュートリアル"
        label.textColor = .systemRed
        label.textAlignment = .center
        return label
    }()
    let explanation: UILabel = {
        let label = UILabel()
        label.text = "・赤に近い色ほど期日が迫っています\n・セルをタップすると詳細な情報にアクセスできます"
        label.textColor = .systemRed
        label.textAlignment = .center
        return label
    }()
    
    init(){
    }
}
