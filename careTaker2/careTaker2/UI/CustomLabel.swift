import UIKit

class CustomLabel: UILabel {
    
    override func draw(_ rect: CGRect) {
        textColor = .black
        textAlignment = NSTextAlignment.center
        font = UIFont.systemFont(ofSize: 50)
        super.draw(rect)
    }

}
