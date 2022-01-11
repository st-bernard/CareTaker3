//
//  LaunchScreenViewController.swift
//  CareTaker3
//
//  Created by Manabu Tonosaki on 2022/01/11.
//

import UIKit
import AVFoundation

class LaunchScreenViewController : UIViewController, AVAudioPlayerDelegate {
    
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
}
