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
    
    var sortedItems: [Item] {
        (items?.allObjects as? [Item] ?? []).sorted(by: { $0.order < $1.order })
    }
    
    var achievementCountString: String {
        String(achievementCount)
    }
    
    var numberOfItemsString: String {
        String(items?.count ?? 0)
    }
    
    var hasItems: Bool {
        (items?.count ?? 0) != 0
    }
    
    var hasNotifications: Bool {
        (notifications?.count ?? 0) != 0
    }
    
    func duplicate(_ context: NSManagedObjectContext) {
        let duplicatedItemList = parentFolder.createNewItemList(
            name: name + " Copied",
            color: color,
            image: image,
            achievementCount: 0,
            displayFormat: displayFormat,
            creationDate: Date(),
            updateDate: Date(),
            order: Int(order) + 1,
            type: type,
            context)
        (items?.allObjects as? [Item])?.forEach({ item in
            item.duplicate(for: duplicatedItemList, context)
        })
    }
    
    @discardableResult
    func createNewItem(name: String, category: String? = nil, weight: Double? = nil, quantity: Int? = nil, state: String = "incomplete", isImportant: Bool = false, note: String? = nil, image: String? = nil, conditions: String? = nil, order: Int, _ context: NSManagedObjectContext) -> Item {
        let newItem = Item(context: context)
        newItem.category = category
        newItem.id = UUID()
        newItem.name = name
        newItem.quantity = quantity != nil ? Int32(quantity!) : 0
        newItem.weight = weight ?? 0
        newItem.state = state
        newItem.isImportant = isImportant
        newItem.note = note
        newItem.image = image
        newItem.conditions = conditions
        newItem.order = Int32(order)
        addToItems(newItem)
        return newItem
    }
    
    @discardableResult
    func createNewNotification(weekdays: String, time: Date, _ context: NSManagedObjectContext) -> Notification {
        let newNotification = Notification(context: context)
        newNotification.creationDate = Date()
        newNotification.weekdays = weekdays
        newNotification.time = time
        addToNotifications(newNotification)
        return newNotification
    }
}
