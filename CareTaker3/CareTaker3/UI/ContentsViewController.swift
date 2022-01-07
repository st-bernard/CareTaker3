import UIKit

//protocol ReceiverDelegate{
//    func reloadView()
//}

class ContentsViewController: UIViewController {
    var content: ContentModel?
    var pickerItems = (1...100).map{ String($0) }

    var pickerView = UIPickerView()
    var contentsViewParts: ContentsViewParts?
    var updateFirebase: FirebaseContentRepository.Updater?
    
    
//    init(content:ContentModel,delegate:ReceiverDelegate) {
                //        self.delegate = delegate
//        self.content = content
//        self.updateFirebase = UpdateFirebase(section: content.section, row: content.row)
//        for i in 1...100 {
//            self.pickerItems.append(String(i))
//        }
//        super.init(nibName: nil, bundle: nil)
//    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let content = content else { fatalError() }

        updateFirebase = FirebaseContentRepository.Updater(section: content.section, row: content.row)

        title = content.name
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "xmark.circle.fill"),
            style: .plain,
            target: self,
            action: #selector(didTapDismissButton(_:))
        )
        navigationItem.rightBarButtonItem?.tintColor = .systemGray
        let subviews = self.view.subviews
        for subview in subviews {
            subview.removeFromSuperview()
        }
        
        view.backgroundColor = .white
        contentsViewParts = ContentsViewParts(
            width: view.frame.width,
            intervalDay: content.interval,
            lastDate: content.lastDate
        )
        
        createPickerView()
        let contentsViewParts = contentsViewParts!
        
        contentsViewParts.yattayoButton.addTarget(self, action: #selector(didTapYattayo(_:)), for: .touchUpInside)
        self.view.addSubview(contentsViewParts.dateSettingTextField)
        self.view.addSubview(contentsViewParts.lastdatelabel)
        self.view.addSubview(contentsViewParts.daylabel)
        self.view.addSubview(contentsViewParts.datelabel)
        self.view.addSubview(contentsViewParts.intervallabel)
        self.view.addSubview(contentsViewParts.yattayoButton)
    }
    
    func createPickerView() {
        pickerView.delegate = self
        guard let contentsViewParts = contentsViewParts else { fatalError() }
        contentsViewParts.dateSettingTextField.inputView = pickerView
        
        let toolbar = UIToolbar()
        toolbar.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 44)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(ContentsViewController.didTapDoneButton))
        toolbar.setItems([doneButton], animated: true)
        contentsViewParts.dateSettingTextField.inputAccessoryView = toolbar
    }
    
    @objc func didTapYattayo(_ sender: YattayoButton) {
        sender.animateView(){
            [weak self] in
            let formatter = DateFormatter()
            formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "ydMMM", options: 0, locale: Locale(identifier: "ja_JP"))
            let today = formatter.string(from: Date())
            self?.updateFirebase?.updateLastDate(withText: today)
            self?.content?.lastDate = today
            self?.viewDidLoad()
        }
    }
    
    @objc func didTapDoneButton() {
        print("----donebutton----")
        contentsViewParts?.dateSettingTextField.endEditing(true)
        guard let strInterval = contentsViewParts?.dateSettingTextField.text,
              let interval = Int(strInterval)
        else { return }
        updateFirebase?.updateInterval(withInt: interval)
        content?.interval = interval
    }
    
    @objc func didTapDismissButton(_ sender: UIButton) {
        // delegate?.reloadView() 以前のアプリでは、親Viewの再描画を期待していた
        dismiss(animated: true)
    }
}

extension ContentsViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerItems.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerItems[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("----didselectRow----")
        contentsViewParts?.dateSettingTextField.text = pickerItems[row]
    }

}

