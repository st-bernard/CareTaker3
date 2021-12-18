import UIKit

class ContentsViewController: UIViewController {
    var content:ContentModel
    var pickerItems = [String]()
    var pickerView = UIPickerView()
    var contentsView: ContentsView!
    
    init(content:ContentModel) {
        self.content = content
        for i in 1...100 {
            self.pickerItems.append(String(i))
        }
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
        contentsView = ContentsView(
            width: view.frame.width,
            intervalDay: content.interval,
            lastDate: content.lastDate,
            name: content.name)
        
        createPickerView()
        
        contentsView.updateButton.addTarget(self, action: #selector(didTapYattayo(_:)), for: .touchUpInside)
//        contentsView.dateSettingTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingDidEnd)
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
    
    func createPickerView() {
        pickerView.delegate = self
        contentsView.dateSettingTextField.inputView = pickerView
        
        let toolbar = UIToolbar()
        toolbar.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 44)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(ContentsViewController.didTapDoneButton))
        toolbar.setItems([doneButton], animated: true)
        contentsView.dateSettingTextField.inputAccessoryView = toolbar
    }
    
    @objc func didTapYattayo(_ sender: UIButton) {
        let formatter = DateFormatter()
        formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "ydMMM", options: 0, locale: Locale(identifier: "ja_JP"))
        let today = formatter.string(from: Date())
        self.content.updateLastDate(withText: today)
        viewDidLoad()
    }
    
//    @objc func textFieldDidChange(_ sender: UITextField) {
//        print("----textField did chaged----")
//        guard let strInterval = sender.text,
//              let interval = Int(strInterval)
//        else { return }
//        self.content.updateInterval(withInt: interval)
//    }
    
    @objc func didTapDoneButton() {
        print("----donebutton----")
        contentsView.dateSettingTextField.endEditing(true)
        guard let strInterval = contentsView.dateSettingTextField.text,
              let interval = Int(strInterval)
        else { return }
        self.content.updateInterval(withInt: interval)
    }
    
    @objc func didTapDismissButton(_ sender: UIButton) {
        dismiss(animated: true, completion: {debugPrint("-----dismiss-----")})
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
        contentsView.dateSettingTextField.text = pickerItems[row]
    }

}

