import UIKit

class YattayoButton: UIButton {

    override func draw(_ rect: CGRect) {
        layer.masksToBounds = true
        layer.cornerRadius = 15.0
        layer.borderColor = UIColor.white.cgColor
        layer.borderWidth = 2
        layer.backgroundColor = UIColor.systemBlue.cgColor
        setTitleColor(.white, for: .normal)
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 14.0)
    }
    
    func animateView(completion: @escaping () -> Void) {
        UIView.animate(
            withDuration: 0.1,
            delay: 0,
            options: .curveEaseIn,
            animations: {
                self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            }
        ){ _ in
            UIView.animate(
                withDuration: 0.1,
                delay: 0,
                options: .curveEaseIn,
                animations: {
                    self.transform = .identity
                }
            ) { _ in
                completion()
            }
        }
    }


}
