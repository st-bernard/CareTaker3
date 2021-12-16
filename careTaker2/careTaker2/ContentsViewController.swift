import UIKit

class ContentsViewController: UIViewController {
    
    var intervalDay:Int
    var lastDate:String
    var name:String
    
    init(content:ContentModel) {
        self.intervalDay = content.interval
        self.lastDate = content.lastDate
        self.name = content.name
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        self.view.addSubview(contentsView.dismissButton)
    }
}
