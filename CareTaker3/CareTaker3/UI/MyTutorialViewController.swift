import UIKit
import AVKit

class MyTutorialViewController: AVPlayerViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let asset = NSDataAsset(name:"CareTaker3Tutorial")
        let videoUrl = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("movie.mp4")
        try! asset!.data.write(to: videoUrl)

        let item = AVPlayerItem(url: videoUrl)
        self.player = AVPlayer(playerItem: item)
        player?.play()
    }
}
