//
//  Notification+CoreDataClass.swift
//  MonoList
//
//  Created by 竹田悠真 on 2021/12/28.
//
//

import SwiftUI
import CoreData

@objc(Notification)
public class Notification: NSManagedObject {
    
    @Environment(\.managedObjectContext) private static var viewContext
    
    @discardableResult
    static func createNewNotification(weekdays: [String], time: Date, for itemList: ItemList) -> Notification {
        let newNotification = Notification(context: viewContext)
        newNotification.weekdays = weekdays.joined(separator: ", ")
        newNotification.time = time
        newNotification.parentItemList = itemList
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return newNotification
    }
}
