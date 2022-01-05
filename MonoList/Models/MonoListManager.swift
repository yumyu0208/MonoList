//
//  MonoListManager.swift
//  MonoList
//
//  Created by 竹田悠真 on 2021/12/30.
//

import SwiftUI
import CoreData

class MonoListManager: ObservableObject {
    
    @discardableResult
    func createNewFolder(name: String, image: String, order: Int, _ context: NSManagedObjectContext) -> Folder {
        let newFolder = Folder(context: context)
        newFolder.name = name
        newFolder.image = image
        newFolder.order = Int32(order)
        return newFolder
    }
    
    func fetchFolders(context: NSManagedObjectContext) -> [Folder] {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Folder")
        do {
            let folders = try context.fetch(request) as! [Folder]
            return folders
        }
        catch {
            fatalError("Failed to fetch folders")
        }
    }
    
    func fetchItemLists(context: NSManagedObjectContext) -> [ItemList] {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "ItemList")
        do {
            let itemLists = try context.fetch(request) as! [ItemList]
            return itemLists
        }
        catch {
            fatalError("Failed to fetch item lists")
        }
    }
    
    func fetchItems(context: NSManagedObjectContext) -> [Item] {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Item")
        do {
            let items = try context.fetch(request) as! [Item]
            return items
        }
        catch {
            fatalError("Failed to fetch items")
        }
    }
    
    @discardableResult
    func createSamples(context: NSManagedObjectContext) -> [Folder] {
        let listsFolder = createNewFolder(name: K.defaultName.lists, image: "checklist", order: 0, context)
        let workList = listsFolder.createNewItemList(name: "Work", color: K.listColors.basic.blue, image: "briefcase", order: 0, context)
        
        workList.createNewItem(name: "Laptop", isImportant: true, order: 0, context)
        workList.createNewItem(name: "Pen", order: 1, context)
        workList.createNewItem(name: "Pocket Book", order: 2, context)
        workList.createNewItem(name: "Documents", order: 3, context)
        workList.createNewItem(name: "Watch", order: 4, context)
        
        let shoppingList = listsFolder.createNewItemList(name: "Shopping", color: K.listColors.basic.yellow, image: "cart", order: 1, context)
        
        shoppingList.createNewItem(name: "Laptop", isImportant: true, order: 0, context)
        shoppingList.createNewItem(name: "Pen", order: 1, context)
        shoppingList.createNewItem(name: "Pocket Book", order: 2, context)
        shoppingList.createNewItem(name: "Documents", order: 3, context)
        shoppingList.createNewItem(name: "Watch", order: 4, context)
        
        let collegeList = listsFolder.createNewItemList(name: "College", color: K.listColors.basic.green, image: "graduationcap", order: 2, context)
        
        collegeList.createNewItem(name: "Laptop", isImportant: true, order: 0, context)
        collegeList.createNewItem(name: "Pen", order: 1, context)
        collegeList.createNewItem(name: "Pocket Book", order: 2, context)
        collegeList.createNewItem(name: "Documents", order: 3, context)
        collegeList.createNewItem(name: "Watch", order: 4, context)
        
        let driveList = listsFolder.createNewItemList(name: "Drive", color: K.listColors.basic.lightBlue, image: "car", order: 3, context)
        
        driveList.createNewItem(name: "Laptop", isImportant: true, order: 0, context)
        driveList.createNewItem(name: "Pen", order: 1, context)
        driveList.createNewItem(name: "Pocket Book", order: 2, context)
        driveList.createNewItem(name: "Documents", order: 3, context)
        driveList.createNewItem(name: "Watch", order: 4, context)
        
        let campList = listsFolder.createNewItemList(name: "Camp", color: K.listColors.basic.orange, image: "flame", order: 4, context)
        
        campList.createNewItem(name: "Laptop", isImportant: true, order: 0, context)
        campList.createNewItem(name: "Pen", order: 1, context)
        campList.createNewItem(name: "Pocket Book", order: 2, context)
        campList.createNewItem(name: "Documents", order: 3, context)
        campList.createNewItem(name: "Watch", order: 4, context)
        
        let fishingList = listsFolder.createNewItemList(name: "Fishing", color: K.listColors.basic.gray, image: "ferry", order: 5, context)
        
        fishingList.createNewItem(name: "Laptop", isImportant: true, order: 0, context)
        fishingList.createNewItem(name: "Pen", order: 1, context)
        fishingList.createNewItem(name: "Pocket Book", order: 2, context)
        fishingList.createNewItem(name: "Documents", order: 3, context)
        fishingList.createNewItem(name: "Watch", order: 4, context)
        
        let sportsList = listsFolder.createNewItemList(name: "Sports", color: K.listColors.basic.purple, image: "sportscourt", order: 6, context)
        
        sportsList.createNewItem(name: "Laptop", isImportant: true, order: 0, context)
        sportsList.createNewItem(name: "Pen", order: 1, context)
        sportsList.createNewItem(name: "Pocket Book", order: 2, context)
        sportsList.createNewItem(name: "Documents", order: 3, context)
        sportsList.createNewItem(name: "Watch", order: 4, context)
        
        let domesticTravelList = listsFolder.createNewItemList(name: "Domestic Travel", color: K.listColors.basic.pink, image: "suitcase", order: 7, context)
        
        domesticTravelList.createNewItem(name: "Laptop", isImportant: true, order: 0, context)
        domesticTravelList.createNewItem(name: "Pen", order: 1, context)
        domesticTravelList.createNewItem(name: "Pocket Book", order: 2, context)
        domesticTravelList.createNewItem(name: "Documents", order: 3, context)
        domesticTravelList.createNewItem(name: "Watch", order: 4, context)
        
        let overseasTravelList = listsFolder.createNewItemList(name: "Overseas Travel", color: K.listColors.basic.red, image: "airplane", order: 8, context)
        
        overseasTravelList.createNewItem(name: "Laptop", isImportant: true, order: 0, context)
        overseasTravelList.createNewItem(name: "Pen", order: 1, context)
        overseasTravelList.createNewItem(name: "Pocket Book", order: 2, context)
        overseasTravelList.createNewItem(name: "Documents", order: 3, context)
        overseasTravelList.createNewItem(name: "Watch", order: 4, context)
        
        let favoriteFolder = createNewFolder(name: K.defaultName.favorite, image: "star", order: 1, context)
        
        do {
            try context.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return [favoriteFolder, listsFolder]
    }
}
