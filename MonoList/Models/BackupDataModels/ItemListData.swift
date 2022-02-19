//
//  ItemListData.swift
//  MonoList
//
//  Created by 竹田悠真 on 2022/02/07.
//

import Foundation
import CoreData

struct ItemListData: Codable {
    var achievementCount: Int
    var color: String
    var creationDate: Date
    var displayFormat: String
    var hideCompleted: Bool
    var iconName: String
    var id: UUID
    var image: String
    var notificationIsActive: Bool
    var name: String
    var order: Int
    var primaryColor: String?
    var secondaryColor: String?
    var tertiaryColor: String?
    var type: String
    var unitLabel: String
    var updateDate: Date
    var itemDataArray: [ItemData]?
    var notificationDataArray: [NotificationData]?
    
    func createItemList(context: NSManagedObjectContext) -> ItemList {
        let itemList = ItemList(context: context)
        itemList.achievementCount = Int32(achievementCount)
        itemList.color = color
        itemList.creationDate = creationDate
        itemList.displayFormat = displayFormat
        itemList.hideCompleted = hideCompleted
        itemList.iconName = iconName
        itemList.id = id
        itemList.image = image
        itemList.notificationIsActive = notificationIsActive
        itemList.name = name
        itemList.order = Int32(order)
        itemList.primaryColor = primaryColor
        itemList.secondaryColor = secondaryColor
        itemList.tertiaryColor = tertiaryColor
        itemList.type = type
        itemList.unitLabel = unitLabel
        itemList.updateDate = updateDate
        itemDataArray?.forEach {
            itemList.addToItems($0.createItem(context: context))
        }
        notificationDataArray?.forEach {
            itemList.addToNotifications($0.createNotification(context: context))
        }
        return itemList
    }
}
