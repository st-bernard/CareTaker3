//
//  ViewController+Notification.swift
//  CareTaker3
//
//  Created by Manabu Tonosaki on 2022/01/06.
//

import UIKit

extension UIViewController {

    // 自分の端末に対して、ローカル通知を出す
    func pushLocal(title: String, body: String, delaySeconds: Double = 0.0, sound: UNNotificationSound = .default) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = sound

        let intervalTrigger = UNTimeIntervalNotificationTrigger(timeInterval: delaySeconds, repeats: false)
        let request = UNNotificationRequest(identifier: "localpush-\(title)-\(body)", content: content, trigger: intervalTrigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil) // 通知登録
    }
    
    enum DateTimeParts: String {
        case year4 = "y"
        case month = "M"
        case day = "d"
        case hour24 = "H"
        case minute = "m"
        case second = "s"
    }
    
    // y/M/d H:m:s
    func getDateTimePart(_ date: Date, part: DateTimeParts) -> Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = part.rawValue
        let partString = dateFormatter.string(from: date)
        return Int(partString)!
    }
    
    // 指定した日時にローカル通知
    func pushLocal(title: String, body: String, at: DateComponents, sound: UNNotificationSound = .default) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = sound
        let trigger = UNCalendarNotificationTrigger(dateMatching: at, repeats: false)
        let request = UNNotificationRequest(identifier: "localpush-\(title)-\(body)", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil) // 通知登録
    }
}
