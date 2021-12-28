//
//  Item+CoreDataClass.swift
//  MonoList
//
//  Created by 竹田悠真 on 2021/12/28.
//
//

import SwiftUI
import CoreData

@objc(Item)
public class Item: NSManagedObject {
    
    @Environment(\.managedObjectContext) private static var viewContext
    
    @discardableResult
    static func createNewItem(name: String, quantity: Int? = nil, state: String = "incomplete", isImportant: Bool = false, note: String? = nil, image: String? = nil, conditions: String? = nil, for itemList: ItemList) -> Item {
        let newItem = Item(context: viewContext)
        newItem.id = UUID()
        newItem.name = name
        newItem.quantity = quantity != nil ? Int32(quantity!) : 0
        newItem.state = state
        newItem.isImportant = isImportant
        newItem.note = note
        newItem.image = image
        newItem.conditions = conditions
        newItem.parentItemList = itemList
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return newItem
    }
}
