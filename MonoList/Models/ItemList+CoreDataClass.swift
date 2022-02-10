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
    
    var isNew: Bool {
        name == K.defaultName.newItemList
    }
    
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
    
    var creationDateString: String {
        string(from: creationDate)
    }
    
    var lastModifiedDateString: String {
        string(from: updateDate)
    }
    
    var totalWeight: Double {
        guard let items = items?.allObjects as? [Item] else { return 0 }
        let weights = items.map { $0.weight * Double($0.quantity) }
        let totalWeight = weights.reduce(0, +)
        return totalWeight
    }
    
    func string(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.locale = Locale.current
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        return dateFormatter.string(from: date)
    }
    
    static func delete(index: Int, itemLists: FetchedResults<ItemList>, _ context: NSManagedObjectContext) {
        // Delete All Items
        if let items = itemLists[index].items?.allObjects as? [Item] {
            items.forEach { item in
                context.delete(item)
            }
        }
        // Delete All Notifications
        if let notifications = itemLists[index].notifications?.allObjects as? [Notification] {
            notifications.forEach { notification in
                context.delete(notification)
            }
        }
        // Delete All Histories
        // ...
        
        context.delete(itemLists[index])
        if index != itemLists.count-1 {
            for index in index+1 ... itemLists.count-1 {
                itemLists[index].order -= 1
            }
        }
    }
    
    func duplicate(_ context: NSManagedObjectContext) {
        let duplicatedItemList = parentFolder.createNewItemList(
            name: name + " Copied",
            color: color,
            primaryColor: primaryColor,
            secondaryColor: secondaryColor,
            tertiaryColor: tertiaryColor,
            iconName: iconName,
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
    func createNewItem(name: String, weight: Double? = nil, quantity: Int? = nil, isCompleted: Bool = false, isImportant: Bool = false, note: String? = nil, image: String? = nil, conditions: String? = nil, category: Category? = nil, order: Int, _ context: NSManagedObjectContext) -> Item {
        let newItem = Item(context: context)
        newItem.id = UUID()
        newItem.name = name
        newItem.quantity = quantity != nil ? Int32(quantity!) : 0
        newItem.weight = weight ?? 0
        newItem.isCompleted = isCompleted
        newItem.isImportant = isImportant
        newItem.note = note
        newItem.image = image
        newItem.conditions = conditions
        newItem.order = Int32(order)
        newItem.category = category
        addToItems(newItem)
        return newItem
    }
    
    enum Order {
        case important
        case category
        case heavy
        case light
        case many
        case few
    }
    
    func sortItems(order: Order) {
        guard let items = items?.allObjects as? [Item] else { return }
        var sortedItems: [Item]?
        switch order {
        case .important:
            sortedItems = items.sorted { lhs, rhs in lhs.isImportant}
        case .category:
            sortedItems = items.sorted { lhs, rhs in
                if let lhs = lhs.category, let rhs = rhs.category {
                    return lhs.order < rhs.order
                } else {
                    return lhs.order < rhs.order
                }
            }
        case .heavy:
            sortedItems = items.sorted { $0.weight > $1.weight }
        case .light:
            sortedItems = items.sorted { $0.weight < $1.weight }
        case .many:
            sortedItems = items.sorted { $0.quantity > $1.quantity }
        case .few:
            sortedItems = items.sorted { $0.quantity < $1.quantity }
        }
        guard let sortedItems = sortedItems else { return }
        var count: Int32 = 0
        for item in sortedItems {
            item.order = count
            count += 1
        }
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
    
    
    func data() -> ItemListData {
        var itemDataArray: [ItemData]?
        if let items = items?.allObjects as? [Item] {
            itemDataArray = items.map { $0.data() }
        }
        var notificationDataArray: [NotificationData]?
        if let notifications = notifications?.allObjects as? [Notification] {
            notificationDataArray = notifications.map { $0.data() }
        }
        return ItemListData(achievementCount: Int(achievementCount),
                            color: color,
                            creationDate: creationDate,
                            displayFormat: displayFormat,
                            iconName: iconName,
                            id: id,
                            image: image,
                            notificationIsActive: notificationIsActive,
                            name: name,
                            order: Int(order),
                            primaryColor: primaryColor,
                            secondaryColor: secondaryColor,
                            tertiaryColor: tertiaryColor,
                            type: type,
                            updateDate: updateDate,
                            itemDataArray: itemDataArray,
                            notificationDataArray: notificationDataArray)
    }
}
