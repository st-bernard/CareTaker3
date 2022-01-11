//
//  LaunchScreenViewController.swift
//  CareTaker3
//
//  Created by Manabu Tonosaki on 2022/01/11.
//

import UIKit
import AVFoundation

class AboutViewController : UIViewController, AVAudioPlayerDelegate {
    
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var poodleImage: UIImageView!
    var audioPlayer: AVAudioPlayer!
    
    func playSound(name: String) {
        
        do {
            let asset = NSDataAsset(name: name)
            audioPlayer = try AVAudioPlayer(data: asset!.data, fileTypeHint: "mp3")
            audioPlayer.delegate = self
            audioPlayer.play()
        } catch {
        }
    }
    
    override func viewDidLoad() {
        playSound(name: "ToypoodleSound")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        poodleImage.alpha = 0.0
        logoImage.alpha = 0.0
        let rota0 = CGAffineTransform(rotationAngle: 0.0)
        let rota1 = CGAffineTransform(rotationAngle: 120.0)
        logoImage.transform = rota1

        UIView.animate(withDuration: 2.0, delay: 0.5, options: [.curveEaseIn],
        animations: {
            self.poodleImage.alpha = 1.0
        })
        UIView.animate(withDuration: 1.0, delay: 0.5, options: [.curveEaseOut],
        animations: {
            self.logoImage.transform = rota0
            self.logoImage.alpha = 1.0
        })
    }
}
