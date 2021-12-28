//
//  MyDetailView.swift
//  CareTaker3
//
//  Created by Manabu Tonosaki on 2021/12/28.
//

import UIKit
import simd

class MyDetailView : UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var intervalTextField: UITextField!
    
    var content: ContentModel?
    
    override func viewDidLoad() {
        
        // 空白領域タップでキーボード閉じる仕組み
        let tapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGestureRecognizer.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGestureRecognizer)
        
        // コントロールを初期化
        guard let content = content else {
            fatalError("実行前に contentインスタンスを紐づけてください")
        }
        title = content.name
        intervalTextField.text = String(content.interval)
        datePicker.date = DateUtils.dateFromString(string: content.lastDate + " 00:00:00 +00:00", format: "yyyy年MM月dd日 HH:mm:ss Z")
    }
    
    
    @IBAction func didTapDoneButton(_ sender: Any) {

        let content = content!

//        let d = DateUtils.dateFromString(string: content.lastDate + " 00:00:00 +00:00", format: "yyyy年MM月dd日 HH:mm:ss Z")
//        let d2 = Calendar.current.date(byAdding: .day, value: -1, to: d)!
        let d2 = Date()
        
        let formatter = DateFormatter()
        formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "ydMMM", options: 0, locale: Locale(identifier: "ja_JP"))
        let today = formatter.string(from: d2)
        let updateFirebase = UpdateFirebase(section: content.section, row: content.row)
        updateFirebase.updateLastDate(withText:today)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func intervalEditingDidEnd(_ sender: Any) {

        let content = content!
        if let val = Int(intervalTextField.text ?? "x") {
            if val != content.interval {
                if val <= 0 || val > 366 {
                    alert(caption: "WARNING", message: "指定した値は Intervalとして使えません", button1: "Cancel"){
                        () in
                        DispatchQueue.main.async {
                            self.intervalTextField.text = "\(content.interval)"
                        }
                    }
                } else {
                    let updateFirebase = UpdateFirebase(section: content.section, row: content.row)
                    updateFirebase.updateInterval(withInt: val)
                }
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        guard let content = content else {
            return
        }
        if let val = Int(intervalTextField.text ?? "x") {
            if val != content.interval {
                if val > 0 || val <= 366 {
                    let updateFirebase = UpdateFirebase(section: content.section, row: content.row)
                    updateFirebase.updateInterval(withInt: val)
                } else {
                    print("intervalに \(intervalTextField.text ?? "nil") を入力してたが 無視した")
                }
            }
        }
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }

    // MacのキーボードでEnter押した時に、キーボードを閉じる
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
    @IBAction func datePrimaryActionTriggered(_ sender: Any) {

        // 強制的に元の日付にもどして、編集を無力化する
        let content = content!
        datePicker.date = DateUtils.dateFromString(string: content.lastDate + " 00:00:00 +00:00", format: "yyyy年MM月dd日 HH:mm:ss Z")
    }
}