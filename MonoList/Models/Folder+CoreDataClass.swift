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
    
    var isDefault: Bool {
        name == K.defaultName.lists
    }
    
    var isNew: Bool {
        name == K.defaultName.newFolder
    }
    
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
                        NotificationManager().deletePendingNotificationRequests([notification])
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
    func createNewItemList(name: String,
                           color: String,
                           primaryColor: String? = nil,
                           secondaryColor: String? = nil,
                           tertiaryColor: String? = nil,
                           iconName: String,
                           image: String,
                           achievementCount: Int = 0,
                           displayFormat: String = DefaultValues.listForm,
                           hideCompleted: Bool = DefaultValues.hideCompleted,
                           creationDate: Date = Date(),
                           updateDate: Date = Date(),
                           order: Int,
                           type: String = "belongings",
                           unitLabel: String = DefaultValues.unitLabel,
                           notificationIsActive: Bool = false,
                           categoryIsHidden: Bool = true,
                           weightIsHidden: Bool = true,
                           quantityIsHidden: Bool = true,
                           _ context: NSManagedObjectContext) -> ItemList {
        let newItemList = ItemList(context: context)
        newItemList.id = UUID()
        newItemList.name = name
        newItemList.color = color
        newItemList.primaryColor = primaryColor
        newItemList.secondaryColor = secondaryColor
        newItemList.tertiaryColor = tertiaryColor
        newItemList.iconName = iconName
        newItemList.image = image
        newItemList.achievementCount = Int32(achievementCount)
        newItemList.displayFormat = displayFormat
        newItemList.hideCompleted = hideCompleted
        newItemList.creationDate = creationDate
        newItemList.updateDate = updateDate
        newItemList.order = Int32(order)
        newItemList.type = type
        newItemList.unitLabel = unitLabel
        newItemList.notificationIsActive = notificationIsActive
        newItemList.categoryIsHidden = categoryIsHidden
        newItemList.weightIsHidden = weightIsHidden
        newItemList.quantityIsHidden = quantityIsHidden
        addToItemLists(newItemList)
        return newItemList
    }
    
    func orderItemLists() {
        guard let itemLists = itemLists?.allObjects as? [ItemList] else { return }
        let orderedItemLists = itemLists.sorted { $0.order < $1.order }
        var count: Int32 = 0
        for itemList in orderedItemLists {
            if itemList.order != count {
                itemList.order = count
            }
            count += 1
            itemList.orderItems()
        }
    }
    
    func data() -> FolderData {
        var itemListDataArray: [ItemListData]?
        if let itemLists = itemLists?.allObjects as? [ItemList] {
            itemListDataArray = itemLists.map { $0.data() }
        }
        return FolderData(image: image,
                          name: name,
                          order: Int(order),
                          itemListDataArray: itemListDataArray)
    }
}
