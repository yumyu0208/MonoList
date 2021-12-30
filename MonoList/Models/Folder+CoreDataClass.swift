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
    func createNewItemList(name: String, color: String, image: String, achievementCount: Int = 0, displayFormat: String = "list", creationDate: Date = Date(), updateDate: Date = Date(), type: String = "belongings") -> ItemList {
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
    func addItemList(name: String = "default_newList", color: String = K.listColors.basic.green, image: String = "checklist") -> ItemList {
        let newItemList = createNewItemList(name: name, color: color, image: image)
        addToItemLists(newItemList)
        saveData()
        return newItemList
    }
}
