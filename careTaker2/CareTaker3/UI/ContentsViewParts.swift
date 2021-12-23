import UIKit

class ContentsViewParts {
    let intervallabel = CustomLabel()
    let datelabel = CustomLabel()
    let daylabel = CustomLabel()
    let dateSettingTextField = UITextField()
    let lastdatelabel = CustomLabel()
    let yattayoButton = YattayoButton()
    
    init(width:CGFloat, intervalDay: Int, lastDate: String){
        intervallabel.frame = CGRect(x: 0, y: 110, width: width, height: 30)
        intervallabel.text = "🕗実施する周期"
        
        datelabel.frame = CGRect(x: 0, y: 350, width: width, height: 30)
        datelabel.text = "🗓実施した日"
        
        daylabel.frame = CGRect(x: 200, y: 180, width: 100, height: 50)
        daylabel.text = "日"
        
        lastdatelabel.frame = CGRect(x: 0, y: 420, width: width, height: 50)
        lastdatelabel.text = lastDate
        
        dateSettingTextField.frame = CGRect(x: 80, y: 180, width: 100, height: 50)
        dateSettingTextField.text = intervalDay.description
        dateSettingTextField.font = UIFont.systemFont(ofSize: 50)
        dateSettingTextField.backgroundColor = .systemCyan
        
        yattayoButton.frame = CGRect(x: 50, y: 520, width: 300, height: 50)
        yattayoButton.setTitle("ヤッタヨ！！", for: .normal)
    }
}
