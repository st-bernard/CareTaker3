import UIKit

class ContentsViewController: UIViewController {
    
    var content:ContentModel
    
    init(content:ContentModel) {
        self.content = content
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let subviews = self.view.subviews
        for subview in subviews {
            subview.removeFromSuperview()
        }
        view.backgroundColor = .white
        let contentsView = ContentsView(
            width: view.frame.width,
            intervalDay: content.interval,
            lastDate: content.lastDate,
            name: content.name)
        
        contentsView.updateButton.addTarget(self, action: #selector(didTapYattayo(_:)), for: .touchUpInside)
        contentsView.dateSettingTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingDidEnd)
        contentsView.dismissButton.addTarget(self, action: #selector(didTapDismissButton(_:)), for: .touchUpInside)
        self.view.addSubview(contentsView.dateSettingTextField)
        self.view.addSubview(contentsView.lastdatelabel)
        self.view.addSubview(contentsView.daylabel)
        self.view.addSubview(contentsView.datelabel)
        self.view.addSubview(contentsView.intervallabel)
        self.view.addSubview(contentsView.listItemlabel)
        self.view.addSubview(contentsView.updateButton)
        self.view.addSubview(contentsView.dismissButton)
    }
    
    @objc func didTapYattayo(_ sender: UIButton) {
        let formatter = DateFormatter()
        formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "ydMMM", options: 0, locale: Locale(identifier: "ja_JP"))
        let today = formatter.string(from: Date())
        self.content.updateLastDate(withText: today)
//        print(self.view.subviews)
//        guard let lastDateLabel = self.view.subviews[1] as? UILabel else { return }
//        lastDateLabel.text = today
        viewDidLoad()
    }
    
    @objc func textFieldDidChange(_ sender: UITextField) {
        guard let strInterval = sender.text,
              let interval = Int(strInterval)
        else { return }
        self.content.updateInterval(withInt: interval)
    }
    
    @objc func didTapDismissButton(_ sender: UIButton) {
        dismiss(animated: true, completion: {debugPrint("-----dismiss-----")})
    }
}
