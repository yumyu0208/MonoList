//
//  ItemList+CoreDataClass.swift
//  MonoList
//
//  Created by 竹田悠真 on 2021/12/28.
//
//

import SwiftUI
import CoreData


public class ItemList: NSManagedObject {
    
    @Environment(\.managedObjectContext) private static var viewContext
    
    @discardableResult
    static func createNewItemList(name: String, color: String, image: String, achievementCount: Int = 0, displayFormat: String = "list", creationDate: Date = Date(), updateDate: Date = Date(), type: String = "belongings") -> ItemList {
        let newItemList = ItemList(context: viewContext)
        newItemList.id = UUID()
        newItemList.name = name
        newItemList.color = color
        newItemList.image = image
        newItemList.achievementCount = Int32(achievementCount)
        newItemList.displayFormat = displayFormat
        newItemList.creationDate = creationDate
        newItemList.updateDate = updateDate
        newItemList.type = type
        return newItemList
    }
    
    @discardableResult
    func addItem(name: String) -> Item {
        let newItem = Item.createNewItem(name: name)
        addToItems(newItem)
        do {
            try Self.viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return newItem
    }
    
    @discardableResult
    func addNotification(weekdays: [String], time: Date) -> Notification {
        let newNotification = Notification.createNewNotification(weekdays: weekdays, time: time)
        addToNotifications(newNotification)
        do {
            try Self.viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return newNotification
    }
}
