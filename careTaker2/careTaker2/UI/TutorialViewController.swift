import UIKit

class TutorialViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let TutorialView = TutorialView()
        
        title = "チュートリアル"
        //self.view.backgroundColor = .magenta
        TutorialView.TutorialGif.frame = CGRect(
            x: self.view.frame.size.width*0.2,
            y: self.view.frame.size.height*0.2,
            width: self.view.frame.size.width*0.6,
            height: self.view.frame.size.height*0.6
        )
        view.addSubview(TutorialView.TutorialGif)
    }
    
}
