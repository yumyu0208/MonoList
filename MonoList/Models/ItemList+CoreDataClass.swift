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
    
    @discardableResult
    func createNewItem(name: String, quantity: Int? = nil, state: String = "incomplete", isImportant: Bool = false, note: String? = nil, image: String? = nil, conditions: String? = nil, order: Int, _ context: NSManagedObjectContext) -> Item {
        let newItem = Item(context: context)
        newItem.id = UUID()
        newItem.name = name
        newItem.quantity = quantity != nil ? Int32(quantity!) : 0
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
    func createNewNotification(weekdays: [String], time: Date, _ context: NSManagedObjectContext) -> Notification {
        let newNotification = Notification(context: context)
        newNotification.weekdays = weekdays.joined(separator: ", ")
        newNotification.time = time
        addToNotifications(newNotification)
        return newNotification
    }
}
