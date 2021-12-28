//
//  ItemList+CoreDataClass.swift
//  MonoList
//
//  Created by 竹田悠真 on 2021/12/28.
//
//

import SwiftUI
import CoreData

@objc(ItemList)
public class ItemList: NSManagedObject {
    
    @Environment(\.managedObjectContext) private static var viewContext
    
    @discardableResult
    static func createNewItemList(name: String, color: String, image: String, achievementCount: Int = 0, displayFormat: String = "list", creationDate: Date = Date(), updateDate: Date = Date(), type: String = "belongings", for folder: Folder) -> ItemList {
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
        newItemList.parentFolder = folder
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return newItemList
    }
    
    @discardableResult
    func addItem(name: String) -> Item {
        return Item.createNewItem(name: name, for: self)
    }
}
