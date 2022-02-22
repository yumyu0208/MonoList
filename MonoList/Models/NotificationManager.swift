//
//  NotificationManager.swift
//  MonoList
//
//  Created by 竹田悠真 on 2022/02/21.
//

import UIKit

class NotificationManager {
    
    let center = UNUserNotificationCenter.current()
    
    func setLocalNotifications(_ notifications: [Notification]) {
        center.getNotificationSettings { settings in
            guard (settings.authorizationStatus == .authorized) ||
                  (settings.authorizationStatus == .provisional) else { return }
            notifications.forEach { notification in
                self.setNotification(notification)
            }
        }
    }
    
    private func setNotification(_ notification: Notification) {
        // Content
        let content = UNMutableNotificationContent()
        content.title = notification.parentItemList.name
        //content.body = "Body"
        content.sound = UNNotificationSound.default
        
        let notificationCenter = UNUserNotificationCenter.current()
        
        if notification.isRepeat {
            let weekdays = notification.weekdays.map { Int(String($0)) ?? -1 }.filter { $0 >= 0 && $0 < 7 }
            let triggers = weekdays.map { weekday -> UNCalendarNotificationTrigger in
                var dateComponents = DateComponents()
                dateComponents.calendar = Calendar.current
                dateComponents.weekday = weekday
                dateComponents.hour = notification.hour
                dateComponents.minute = notification.minute
                return UNCalendarNotificationTrigger(
                         dateMatching: dateComponents, repeats: true)
            }
            triggers.forEach { trigger in
                let uuidString = notification.id.uuidString
                let request = UNNotificationRequest(identifier: uuidString,
                            content: content, trigger: trigger)
                notificationCenter.add(request) { (error) in
                    if let error = error {
                       print(error.localizedDescription)
                    }
                }
            }
        } else {
            var dateComponents = DateComponents()
            dateComponents.calendar = Calendar.current
            dateComponents.year = notification.year
            dateComponents.month = notification.month
            dateComponents.day = notification.day
            dateComponents.hour = notification.hour
            dateComponents.minute = notification.minute
            let trigger = UNCalendarNotificationTrigger(
                     dateMatching: dateComponents, repeats: false)
            let uuidString = notification.id.uuidString
            let request = UNNotificationRequest(identifier: uuidString,
                        content: content, trigger: trigger)
            notificationCenter.add(request) { (error) in
                if let error = error {
                   print(error.localizedDescription)
                }
            }
        }
    }
    
    func deleteNotifications(_ notifications: [Notification]) {
        let ids = notifications.map { $0.id.uuidString }
        center.removePendingNotificationRequests(withIdentifiers: ids)
    }
}
