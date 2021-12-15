import UIKit

class ContentsViewController: UIViewController {
    
    var intervalDay:String = "30"
    var lastDate:String = "2021-12-15"
    var name:String = "hair"

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let contentsView = ContentsView(width: view.frame.width, intervalDay: intervalDay, lastDate: lastDate, name: name)
        
        self.view.addSubview(contentsView.dateSettingTextField)
        self.view.addSubview(contentsView.lastdatelabel)
        self.view.addSubview(contentsView.daylabel)
        self.view.addSubview(contentsView.datelabel)
        self.view.addSubview(contentsView.intervallabel)
        self.view.addSubview(contentsView.listItemlabel)
        self.view.addSubview(contentsView.updateButton)
    }
}
