//
//  ViewController+Notification.swift
//  CareTaker3
//
//  Created by Manabu Tonosaki on 2022/01/06.
//

import UIKit

class PushNotification {

    // self.modelにあるデータに対して、PUSH通知を登録する
    class func registerLocalPush(item: ContentModel) {
        
        // Demo用、PUSH通知時刻を30秒後に
        if item.name == "トイレットペーパーとか、品名を指定したものがDemoとして早く通知来る" {
            let demoTime = Calendar.current.date(byAdding: .second, value: 30, to: Date())!
            var nextDueDateTime = DateComponents()
            nextDueDateTime.year = DateUtils.getDateTimePart(demoTime, part: .year4)
            nextDueDateTime.month = DateUtils.getDateTimePart(demoTime, part: .month)
            nextDueDateTime.day = DateUtils.getDateTimePart(demoTime, part: .day)
            nextDueDateTime.hour = DateUtils.getDateTimePart(demoTime, part: .hour24)
            nextDueDateTime.minute = DateUtils.getDateTimePart(demoTime, part: .minute)
            nextDueDateTime.second = DateUtils.getDateTimePart(demoTime, part: .second)
            print("通知予約(Demo) \(item.name) at \(DateUtils.makeString(nextDueDateTime))")
            pushLocal(id: item.id!, title: "CareTakerからのお知らせ", body: "「\(item.name)」の期限です。", at: nextDueDateTime)
            
        } else {
            guard let nextDueDate = item.getNextDue() else { fatalError() }
            if nextDueDate < Date() {    // 納期過ぎているものは PUSH通知登録しない
                return
            }
            var nextDueDateTime = DateComponents()
            nextDueDateTime.year = DateUtils.getDateTimePart(nextDueDate, part: .year4)
            nextDueDateTime.month = DateUtils.getDateTimePart(nextDueDate, part: .month)
            nextDueDateTime.day = DateUtils.getDateTimePart(nextDueDate, part: .day)
            nextDueDateTime.hour = DateUtils.getDateTimePart(nextDueDate, part: .hour24)
            nextDueDateTime.minute = DateUtils.getDateTimePart(nextDueDate, part: .minute)
            nextDueDateTime.second = DateUtils.getDateTimePart(nextDueDate, part: .second)
            print("通知予約 \(item.name) at \(DateUtils.makeString(nextDueDateTime))")
            pushLocal(id: item.id!, title: "CareTakerからのお知らせ", body: "「\(item.name)」の期限です。", at: nextDueDateTime)
        }
    }
    
    class func registerLocalPush(model: ContentsListModel) {
        
        let activeItems = model.contents.flatMap{ $0 }.compactMap{ $0 }.filter{ $0.isActive }
        for item in activeItems {
            registerLocalPush(item: item)
        }
    }
    
    class func removePushLocal(id: String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id])
    }
    
    class func removePushLocal(ids: [String]) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ids)
    }
    
    // 自分の端末に対して、ローカル通知を出す
    class func pushLocal(id: String, title: String, body: String, delaySeconds: Double = 0.0, sound: UNNotificationSound = .default) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = sound

        let intervalTrigger = UNTimeIntervalNotificationTrigger(timeInterval: delaySeconds, repeats: false)
        let request = UNNotificationRequest(identifier: "localpush-\(id)", content: content, trigger: intervalTrigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil) // 通知登録
    }
    
    // 指定した日時にローカル通知
    class func pushLocal(id: String, title: String, body: String, at: DateComponents, sound: UNNotificationSound = .default) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = sound
        let trigger = UNCalendarNotificationTrigger(dateMatching: at, repeats: false)
        let request = UNNotificationRequest(identifier: "localpush-\(id)", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil) // 通知登録
    }
}
