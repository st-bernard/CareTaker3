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
    var model: ContentsListModel!
    var testTapped: (() -> Void)? = nil
    
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
    
    @IBAction func didTapTestButton(_ sender: Any) {
        let contents = model.contents.flatMap{ $0 }
        for content in contents {
            let updater = FirebaseContentRepository.Updater(section: content.section, row: content.row)
            switch content.name {
                case "髪の毛":
                    updater.updateIsActive(isActive: true)
                    updater.updateLastDate(withText: DateUtils.makeDoneDateText(offsetDays: -1))
                    updater.updateInterval(withInt: 2)
                    updater.updateLocation(isHome: false, locationName: "ＳｕｎｇｏｏｓｅＴＯＫＹＯ", lon: 139.744855555556, lat: 35.646776666667)
                case "ひげ":
                    updater.updateIsActive(isActive: true)
                    updater.updateLastDate(withText: DateUtils.makeDoneDateText(offsetDays: 0))
                    updater.updateInterval(withInt: 2)
                    updater.updateLocation(isHome: true, locationName: "", lon: 0.0, lat: 0.0)
                case "トイレットペーパー":
                    updater.updateIsActive(isActive: true)
                    updater.updateLastDate(withText: DateUtils.makeDoneDateText(offsetDays: -1))
                    updater.updateInterval(withInt: 8)
                    updater.updateLocation(isHome: false, locationName: "ドラッグストア・スマイル　芝浦店", lon: 139.7477275, lat: 35.643013333333)
                case "掃除":
                    updater.updateIsActive(isActive: true)
                    updater.updateLastDate(withText: DateUtils.makeDoneDateText(offsetDays: 0))
                    updater.updateInterval(withInt: 5)
                    updater.updateLocation(isHome: false, locationName: "ケーヨーデイツー三田店", lon: 139.740341944444, lat: 35.646104444443999)
                default:
                    if content.isActive {
                        updater.updateIsActive(isActive: false)
                    }
                    break
            }
        }
        let callback = testTapped
        testTapped = nil
        callback?()
        dismiss(animated: true)
    }
}
