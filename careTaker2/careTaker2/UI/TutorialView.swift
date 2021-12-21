import UIKit

class TutorialView{
    let TutorialGif: UIImageView = {
        let gif = UIImageView()
        gif.loadGif(asset: "Sample")
        return gif
    }()
    
    init(){
    }
}
