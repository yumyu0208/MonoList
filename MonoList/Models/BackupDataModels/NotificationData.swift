//
//  NotificationData.swift
//  MonoList
//
//  Created by 竹田悠真 on 2022/02/07.
//

import Foundation
import CoreData

struct NotificationData: Codable {
    var creationDate: Date
    var id: UUID
    var time: Date
    var weekdays: String
    
    func createNotification(context: NSManagedObjectContext) -> Notification {
        let notification = Notification(context: context)
        notification.creationDate = creationDate
        notification.id = id
        notification.time = time
        notification.weekdays = weekdays
        return notification
    }
}
