import UIKit

class ContentsView {
    let intervallabel = UILabel()
    let datelabel = UILabel()
    let daylabel = UILabel()
    let dateSettingTextField = UITextField()
    let lastdatelabel = UILabel()
    let listItemlabel = UILabel()
    let updateButton = UIButton()
    
    init(width:CGFloat, intervalDay: String, lastDate: String, name: String){
        intervallabel.frame = CGRect(x: 10, y: 10, width: width, height: 30)
        intervallabel.text = "🕗通知周期🔔"
        intervallabel.textColor = .black
        datelabel.frame = CGRect(x: 10, y: 70, width: 100, height: 30)
        datelabel.text = "🗓前回日付"
        datelabel.textColor = .black
        daylabel.frame = CGRect(x: 120, y: 40, width: 100, height: 30)
        daylabel.text = "日"
        dateSettingTextField.frame = CGRect(x: 10, y: 40, width: 100, height: 30)
        dateSettingTextField.text = intervalDay
        dateSettingTextField.backgroundColor = .black
        lastdatelabel.frame = CGRect(x: 10, y: 100, width: 100, height: 30)
        lastdatelabel.text = lastDate

        listItemlabel.text = name
        listItemlabel.frame = CGRect(x: 200, y: 40, width: 100, height: 30)
        updateButton.frame = CGRect(x: 100, y: 500, width: 300, height: 50)
        updateButton.setTitle("ヤッタヨ！！", for: .normal)

    }
}
