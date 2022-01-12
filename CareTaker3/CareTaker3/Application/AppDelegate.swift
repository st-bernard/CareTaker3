//
//  AppDelegate.swift
//  careTaker2
//
//  Created by Yuki Iwama on 2021/12/15.
//

import UIKit
import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        
        initPushNotification()
        
        return true
    }

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {

        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {

    }
    
    func initPushNotification() {
        UNUserNotificationCenter.current().requestAuthorization(    // PUSH通知の受信機能 有効化1
            options: [.alert, .sound, .badge]){
            (granted, _) in
            if granted {
                UNUserNotificationCenter.current().delegate = self
                
            } else {
                print("ERROR: PUSH Authorization error")
            }
        }
    }
    
    // PUSH通知対応
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        print("------ didReceiveRemoteNotification 明示通知")
    }
    
    // サイレント通知対応
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("------ didReceiveRemoteNotification サイレント通知")
        completionHandler(UIBackgroundFetchResult.newData)
    }

    // HACK:アプリがフォアグランドにいるときにPUSHされたイベント処理
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {

        let userInfo = notification.request.content.userInfo
        print("======= PUSH1 \(userInfo)")
        completionHandler([ .badge, .sound, .banner ])
   }

    // HACK:ユーザーが通知バナーをタップした時に発火するイベント処理
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        print("======= PUSH2 \(userInfo)")
        completionHandler()
    }
    
    // トークン取得完了時のイベント
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken token: String?) {

        print("------- Notification token: \(String(describing: token))")

        let dataDict: [String: String] = ["token": token ?? ""]
        NotificationCenter.default.post(
          name: Notification.Name("FCMToken"),
          object: nil,
          userInfo: dataDict
        )
        // If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
      }
}

