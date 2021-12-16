import UIKit

class ContentsView {
    let intervallabel = UILabel()
    let datelabel = UILabel()
    let daylabel = UILabel()
    let dateSettingTextField = UITextField()
    let lastdatelabel = UILabel()
    let listItemlabel = UILabel()
    let updateButton = UIButton()
    
    init(width:CGFloat, intervalDay: Int, lastDate: String, name: String){
        intervallabel.frame = CGRect(x: 10, y: 110, width: width, height: 30)
        intervallabel.text = "🕗実施する周期"
        intervallabel.font = UIFont.systemFont(ofSize: 50)
        intervallabel.textColor = .black
        
        datelabel.frame = CGRect(x: 50, y: 350, width: width, height: 30)
        datelabel.text = "🗓実施した日"
        datelabel.font = UIFont.systemFont(ofSize: 50)
        datelabel.textColor = .black
        
        daylabel.frame = CGRect(x: 200, y: 180, width: 100, height: 50)
        daylabel.text = "日"
        daylabel.font = UIFont.systemFont(ofSize: 50)
        
        dateSettingTextField.frame = CGRect(x: 80, y: 180, width: 100, height: 50)
        dateSettingTextField.text = intervalDay.description
        dateSettingTextField.font = UIFont.systemFont(ofSize: 50)
        dateSettingTextField.backgroundColor = .systemCyan
        
        lastdatelabel.frame = CGRect(x: 60, y: 420, width: width, height: 50)
        lastdatelabel.text = lastDate
        lastdatelabel.font = UIFont.systemFont(ofSize: 50)
        
        listItemlabel.text = name
        listItemlabel.frame = CGRect(x: 150, y: 20, width: 100, height: 50)
        listItemlabel.font = UIFont.systemFont(ofSize: 50)
        
        updateButton.frame = CGRect(x: 50, y: 520, width: 300, height: 50)
        updateButton.setTitle("ヤッタヨ！！", for: .normal)
        updateButton.backgroundColor = .systemBlue

    }
}
