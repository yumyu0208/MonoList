//
//  Folder+CoreDataClass.swift
//  MonoList
//
//  Created by 竹田悠真 on 2021/12/28.
//
//

import SwiftUI
import CoreData


public class Folder: NSManagedObject {
    
    static func delete(index: Int, folders: FetchedResults<Folder>, _ context: NSManagedObjectContext) {
        // Delete All ItemLists
        if let itemLists = folders[index].itemLists?.allObjects as? [ItemList] {
            itemLists.forEach { itemList in
                // Delete All Items
                if let items = itemList.items?.allObjects as? [Item] {
                    items.forEach { item in
                        context.delete(item)
                    }
                }
                // Delete All Notifications
                if let notifications = itemList.notifications?.allObjects as? [Notification] {
                    notifications.forEach { notification in
                        context.delete(notification)
                    }
                }
                // Delete All Histories
                // ...
                
                context.delete(itemList)
            }
        }
        context.delete(folders[index])
        if index != folders.count-1 {
            for index in index+1 ... folders.count-1 {
                folders[index].order -= 1
            }
        }
    }
    
    @discardableResult
    func createNewItemList(name: String, color: String, image: String, achievementCount: Int = 0, displayFormat: String = "list", creationDate: Date = Date(), updateDate: Date = Date(), order: Int, type: String = "belongings", notificationIsActive: Bool = false, _ context: NSManagedObjectContext) -> ItemList {
        let newItemList = ItemList(context: context)
        newItemList.id = UUID()
        newItemList.name = name
        newItemList.color = color
        newItemList.image = image
        newItemList.achievementCount = Int32(achievementCount)
        newItemList.displayFormat = displayFormat
        newItemList.creationDate = creationDate
        newItemList.updateDate = updateDate
        newItemList.order = Int32(order)
        newItemList.type = type
        newItemList.notificationIsActive = notificationIsActive
        addToItemLists(newItemList)
        return newItemList
    }
}
