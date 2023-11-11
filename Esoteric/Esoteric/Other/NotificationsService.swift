//
//  NotificationsService.swift
//  Esoteric
//
//  Created by Alex on 11.11.2023.
//

import UserNotifications
import UIKit

enum NotificationIntervals: Double {
    case fiveSec = 5
}

class UserNotifications: NSObject {

    enum NotificationIdentifieres: String {
        case tarotSpread = "tarotSpread"
    }

    static let shared = UserNotifications()
    private override init() {}

    let notificationCenter = UNUserNotificationCenter.current()

    var badgeNumber: Int {
        get {
            return UserDefaults.standard.integer(forKey: "badgeNumber")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "badgeNumber")
        }
    }

    func requestNotifications() {
        notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            guard granted else { return }
            self.notificationCenter.getNotificationSettings { settings in
                print(settings)

                guard settings.authorizationStatus == .authorized else { return }
            }

        }
        notificationCenter.delegate = self
    }

    func sendTarotSpreadNotification(afterTime: NotificationIntervals) {
        let content = UNMutableNotificationContent()
        content.title = "Tarot App"
        content.body = "Таролог прислал ваш расклад, проверьте в приложении"
        content.sound = UNNotificationSound.default
        content.badge = (badgeNumber + 1) as NSNumber
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: afterTime.rawValue, repeats: false)
        let request = UNNotificationRequest(identifier: NotificationIdentifieres.tarotSpread.rawValue, content: content, trigger: trigger)
        notificationCenter.add(request) { error in
            print(error?.localizedDescription ?? "")
        }
    }
}


extension UserNotifications: UNUserNotificationCenterDelegate {

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.sound, .badge, .banner])
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print(#function)
    }
}
