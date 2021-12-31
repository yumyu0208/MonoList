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
    
    @Environment(\.managedObjectContext) private var viewContext
    
    private func saveData() {
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    @discardableResult
    private func createNewItem(name: String, quantity: Int? = nil, state: String = "incomplete", isImportant: Bool = false, note: String? = nil, image: String? = nil, conditions: String? = nil) -> Item {
        let newItem = Item(context: viewContext)
        newItem.id = UUID()
        newItem.name = name
        newItem.quantity = quantity != nil ? Int32(quantity!) : 0
        newItem.state = state
        newItem.isImportant = isImportant
        newItem.note = note
        newItem.image = image
        newItem.conditions = conditions
        return newItem
    }
    
    @discardableResult
    func addItem(name: String) -> Item {
        let newItem = createNewItem(name: name)
        addToItems(newItem)
        saveData()
        return newItem
    }
    
    @discardableResult
    private func createNewNotification(weekdays: [String], time: Date) -> Notification {
        let newNotification = Notification(context: viewContext)
        newNotification.weekdays = weekdays.joined(separator: ", ")
        newNotification.time = time
        return newNotification
    }
    
    @discardableResult
    func addNotification(weekdays: [String], time: Date) -> Notification {
        let newNotification = createNewNotification(weekdays: weekdays, time: time)
        addToNotifications(newNotification)
        saveData()
        return newNotification
    }
}
