import UIKit
import AVKit

class MyTutorialViewController: AVPlayerViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let mov = NSDataAsset(name: "CareTaker3Tutorial")
        let videoUrl = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("movie.mp4")
        try! mov!.data.write(to: videoUrl)

        let item = AVPlayerItem(url: videoUrl)
        self.player = AVPlayer(playerItem: item)
        player?.play()
    }
}
