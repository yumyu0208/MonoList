//
//  NotificationManager.swift
//  MonoList
//
//  Created by 竹田悠真 on 2022/02/21.
//

import UIKit

class NotificationManager {
    
    let center = UNUserNotificationCenter.current()
    
    private func setLocalNotifications(_ notifications: [Notification]) {
        center.getNotificationSettings { settings in
            guard (settings.authorizationStatus == .authorized) ||
                  (settings.authorizationStatus == .provisional) else { return }
            notifications.forEach { notification in
                if settings.alertSetting == .enabled {
                    self.setNotification(notification, alert: true)
                } else {
                    self.setNotification(notification, alert: false)
                }
            }
        }
    }
    
    private func setNotification(_ notification: Notification, alert: Bool) {
        // Content
        let content = UNMutableNotificationContent()
        if alert {
            content.title = notification.parentItemList.name
            //content.body = "Body"
        }
        
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.removeAllDeliveredNotifications()
        notificationCenter.removeAllPendingNotificationRequests()
        
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
                let uuidString = UUID().uuidString
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
            let uuidString = UUID().uuidString
            let request = UNNotificationRequest(identifier: uuidString,
                        content: content, trigger: trigger)
            notificationCenter.add(request) { (error) in
                if let error = error {
                   print(error.localizedDescription)
                }
            }
        }
    }
}
