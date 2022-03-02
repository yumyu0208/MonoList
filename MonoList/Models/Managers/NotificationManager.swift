//
//  NotificationManager.swift
//  MonoList
//
//  Created by 竹田悠真 on 2022/02/21.
//

import UIKit
import CoreData

class NotificationManager {
    
    let center = UNUserNotificationCenter.current()
    
    func checkNotificationSettings(_ context: NSManagedObjectContext) {
        DispatchQueue.global(qos: .background).async {
            self.center.getNotificationSettings { settings in
                if settings.authorizationStatus == .denied || settings.authorizationStatus == .notDetermined {
                    DispatchQueue.main.async {
                        self.turnAllListNotificationOff(context)
                    }
                }
            }
        }
    }
    
    func turnAllListNotificationOff(_ context: NSManagedObjectContext) {
        deleteAllPendingNotificationRequests()
        let allItemLists = MonoListManager().fetchItemLists(context: context)
        allItemLists.forEach { $0.notificationIsActive = false }
        saveData(context)
    }
    
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
        
        let content = UNMutableNotificationContent()
        content.title = notification.parentItemList.name
        //content.body = notification.dateAndTimeString
        content.sound = UNNotificationSound.default
        content.userInfo = ["ItemListIdentifier": notification.parentItemList.id.uuidString]
        
        if notification.isRepeat {
            let weekdays = notification.weekdays.map { Int(String($0)) ?? -1 }.filter { $0 >= 0 && $0 < 7 }
            let triggers = weekdays.map { weekday -> UNCalendarNotificationTrigger in
                var dateComponents = DateComponents()
                dateComponents.calendar = Calendar.current
                dateComponents.hour = notification.hour
                dateComponents.minute = notification.minute
                dateComponents.weekday = weekday+1
                return UNCalendarNotificationTrigger(
                         dateMatching: dateComponents, repeats: true)
            }
            triggers.forEach { trigger in
                let uuidString = "\(notification.id.uuidString)_repeat_\(trigger.dateComponents.weekday ?? -1)"
                let request = UNNotificationRequest(identifier: uuidString,
                            content: content, trigger: trigger)
                center.add(request) { (error) in
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
            center.add(request) { (error) in
                if let error = error {
                   print(error.localizedDescription)
                }
            }
        }
        
        print("setNotification")
        center.getPendingNotificationRequests { requests in
            print("\(requests.count) Requests")
        }
    }
    
    func deletePendingNotificationRequests(_ notifications: [Notification]) {
        // OneOnly
        let ids = notifications.map { $0.id.uuidString }
        center.removePendingNotificationRequests(withIdentifiers: ids)
        
        // Repeat
        let weekdays = 1...7
        ids.forEach { id in
            let repeatIds = weekdays.map { "\(id)_repeat_\($0)" }
            center.removePendingNotificationRequests(withIdentifiers: repeatIds)
        }
        
        #if DEBUG
        print("deletePendingNotificationRequests")
        center.getPendingNotificationRequests { requests in
            print("\(requests.count) Requests")
        }
        #endif
    }
    
    func deleteAllDeliveredNotificationRequests() {
        center.removeAllDeliveredNotifications()
        
        #if DEBUG
        print("deleteAllDeliveredNotificationRequests")
        center.getPendingNotificationRequests { requests in
            print("\(requests.count) Requests")
        }
        #endif
    }
    
    func deleteAllPendingNotificationRequests() {
        center.removeAllPendingNotificationRequests()
        
        #if DEBUG
        print("deleteAllPendingNotificationRequests")
        center.getPendingNotificationRequests { requests in
            print("\(requests.count) Requests")
        }
        #endif
    }
    
    private func saveData(_ context: NSManagedObjectContext) {
        do {
            try context.save()
            print("Saved")
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
}
