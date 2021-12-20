import UIKit

class ContentsView {
    let intervallabel = UILabel()
    let datelabel = UILabel()
    let daylabel = UILabel()
    let dateSettingTextField = UITextField()
    let lastdatelabel = UILabel()
    let listItemlabel = UILabel()
    let updateButton = UIButton()
    let dismissButton = UIButton()
    
    init(width:CGFloat, intervalDay: Int, lastDate: String, name: String){
        intervallabel.frame = CGRect(x: 0, y: 110, width: width, height: 30)
        intervallabel.text = "🕗実施する周期"
        intervallabel.font = UIFont.systemFont(ofSize: 50)
        intervallabel.textColor = .black
        intervallabel.textAlignment = NSTextAlignment.center
        
        datelabel.frame = CGRect(x: 0, y: 350, width: width, height: 30)
        datelabel.text = "🗓実施した日"
        datelabel.font = UIFont.systemFont(ofSize: 50)
        datelabel.textColor = .black
        datelabel.textAlignment = NSTextAlignment.center
        
        daylabel.frame = CGRect(x: 200, y: 180, width: 100, height: 50)
        daylabel.text = "日"
        daylabel.font = UIFont.systemFont(ofSize: 50)
        
        dateSettingTextField.frame = CGRect(x: 80, y: 180, width: 100, height: 50)
        dateSettingTextField.text = intervalDay.description
        dateSettingTextField.font = UIFont.systemFont(ofSize: 50)
        dateSettingTextField.backgroundColor = .systemCyan
        
        lastdatelabel.frame = CGRect(x: 0, y: 420, width: width, height: 50)
        lastdatelabel.text = lastDate
        lastdatelabel.font = UIFont.systemFont(ofSize: 50)
        lastdatelabel.textAlignment = NSTextAlignment.center
        
        listItemlabel.text = name
        listItemlabel.frame = CGRect(x: 0, y: 20, width: width, height: 50)
        listItemlabel.font = UIFont.systemFont(ofSize: 50)
        listItemlabel.textAlignment = NSTextAlignment.center
        
        updateButton.frame = CGRect(x: 50, y: 520, width: 300, height: 50)
        updateButton.setTitle("ヤッタヨ！！", for: .normal)
        updateButton.backgroundColor = .systemBlue
        
        dismissButton.frame = CGRect(x: 330, y: 20, width: 40, height: 40)
        dismissButton.layer.cornerRadius = 20
//        dismissButton.backgroundColor = .blue
//        dismissButton.setTitle("X", for: .normal)
        let dismissImage = UIImage(named: "circle-x-7")
        dismissButton.setImage(dismissImage, for: .normal)

    }
}
