import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = 10
        self.layer.borderWidth = 5
        self.layer.borderColor = UIColor.systemGray.cgColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        setupUI()
    }
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: 5, y: 0, width: self.contentView.frame.width - 10, height: self.contentView.frame.height)
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 25, weight: UIFont.Weight(rawValue: 1))
        label.textColor = .black
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
}

extension CollectionViewCell {
    private func setupUI() {
        self.addSubview(titleLabel)

    }
}
