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
    
    func orderFolder(context: NSManagedObjectContext) {
        let folders = fetchFolders(context: context)
        let orderedFolders = folders.sorted { $0.order < $1.order }
        var count: Int32 = 0
        for folder in orderedFolders {
            if folder.order != count {
                folder.order = count
            }
            count += 1
            folder.orderItemLists()
        }
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
    
    func deleteAllFolders(context: NSManagedObjectContext) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Folder")
        do {
            let folders = try context.fetch(request) as! [Folder]
            folders.forEach { context.delete($0) }
            Self.saveData(context)
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
    
    func fetchNotifications(context: NSManagedObjectContext) -> [Notification] {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Notification")
        do {
            let notifications = try context.fetch(request) as! [Notification]
            return notifications
        }
        catch {
            fatalError("Failed to fetch notifications")
        }
    }
    
    @discardableResult
    func createSamples(context: NSManagedObjectContext) -> [Folder] {
        let listsFolder = createNewFolder(name: K.defaultName.lists, image: "checklist", order: 0, context)
        let workList = listsFolder.createNewItemList(name: "Work", color: K.colors.basic.blue, iconName: "Work", image: "briefcase", order: 0, notificationIsActive: true, context)
        
        let category1 = CategoryManager.createNewCategory(name: "Money", image: "banknote", order: 0, context)
        let category2 = CategoryManager.createNewCategory(name: "Communication", image: "network", order: 1, context)
        let category3 = CategoryManager.createNewCategory(name: "Tickets", image: "ticket", order: 2, context)
        let category4 = CategoryManager.createNewCategory(name: "Identification", image: "person.text.rectangle", order: 3, context)
        let category5 = CategoryManager.createNewCategory(name: "Car", image: "car", order: 4, context)
        let category6 = CategoryManager.createNewCategory(name: "Medicine", image: "cross", order: 5, context)
        
        
        workList.createNewItem(name: "Laptop", isImportant: true, category: category1, order: 0, context)
        workList.createNewItem(name: "Pen", category: category1, order: 1, context)
        workList.createNewItem(name: "Pocket Book", category: category2, order: 2, context)
        workList.createNewItem(name: "Documents", category: category3, order: 3, context)
        workList.createNewItem(name: "Watch", category: category4, order: 4, context)
        
        workList.createNewRepeatNotification(weekdays: "0", time: Notification.defaultDate, context)
        workList.createNewRepeatNotification(weekdays: "36", time: Date(), context)
        
        let shoppingList = listsFolder.createNewItemList(name: "Shopping", color: K.colors.basic.yellow, iconName: "Shopping Cart", image: "cart", order: 1, notificationIsActive: true, context)
        
        shoppingList.createNewItem(name: "Pen", category: category5, order: 1, context)
        shoppingList.createNewItem(name: "Pocket Book", category: category6, order: 2, context)
        shoppingList.createNewItem(name: "Documents", category: category3, order: 3, context)
        shoppingList.createNewItem(name: "Watch", category: category4, order: 4, context)
        shoppingList.createNewItem(name: "Pen", category: category1, order: 1, context)
        shoppingList.createNewRepeatNotification(weekdays: "0", time: Notification.defaultDate, context)
        shoppingList.createNewRepeatNotification(weekdays: "36", time: Date(), context)
        
        let collegeList = listsFolder.createNewItemList(name: "College", color: K.colors.basic.green, iconName: "School", image: "graduationcap", order: 2, notificationIsActive: true, context)
        
        collegeList.createNewItem(name: "Laptop", isImportant: true, category: category1, order: 0, context)
        collegeList.createNewItem(name: "Pen", category: category1, order: 1, context)
        collegeList.createNewItem(name: "Pocket Book", category: category2, order: 2, context)
        collegeList.createNewItem(name: "Documents", category: category3, order: 3, context)
        collegeList.createNewItem(name: "Watch", category: category4, order: 4, context)
        collegeList.createNewRepeatNotification(weekdays: "0", time: Notification.defaultDate, context)
        collegeList.createNewRepeatNotification(weekdays: "36", time: Date(), context)
        
        let driveList = listsFolder.createNewItemList(name: "Drive", color: K.colors.basic.cyan, iconName: "Car", image: "car", order: 3, notificationIsActive: true, context)
        
        driveList.createNewItem(name: "Laptop", isImportant: true, order: 0, context)
        driveList.createNewItem(name: "Pen", order: 1, context)
        driveList.createNewItem(name: "Pocket Book", order: 2, context)
        driveList.createNewItem(name: "Documents", order: 3, context)
        driveList.createNewItem(name: "Watch", order: 4, context)
        driveList.createNewRepeatNotification(weekdays: "0", time: Notification.defaultDate, context)
        driveList.createNewRepeatNotification(weekdays: "36", time: Date(), context)
        
        let campList = listsFolder.createNewItemList(name: "Camp", color: K.colors.basic.orange, iconName: "Flame", image: "flame", order: 4, notificationIsActive: true, context)
        
        campList.createNewItem(name: "Laptop", isImportant: true, order: 0, context)
        campList.createNewItem(name: "Pen", order: 1, context)
        campList.createNewItem(name: "Pocket Book", order: 2, context)
        campList.createNewItem(name: "Documents", order: 3, context)
        campList.createNewItem(name: "Watch", order: 4, context)
        campList.createNewRepeatNotification(weekdays: "0", time: Notification.defaultDate, context)
        campList.createNewRepeatNotification(weekdays: "36", time: Date(), context)
        
        let fishingList = listsFolder.createNewItemList(name: "Fishing", color: K.colors.basic.gray, iconName: "Ferry", image: "ferry", order: 5, notificationIsActive: true, context)
        
        fishingList.createNewItem(name: "Laptop", isImportant: true, order: 0, context)
        fishingList.createNewItem(name: "Pen", order: 1, context)
        fishingList.createNewItem(name: "Pocket Book", order: 2, context)
        fishingList.createNewItem(name: "Documents", order: 3, context)
        fishingList.createNewItem(name: "Watch", order: 4, context)
        fishingList.createNewRepeatNotification(weekdays: "0", time: Notification.defaultDate, context)
        fishingList.createNewRepeatNotification(weekdays: "36", time: Date(), context)
        
        let sportsList = listsFolder.createNewItemList(name: "Sports", color: K.colors.basic.purple, iconName: "Walk", image: "sportscourt", order: 6, notificationIsActive: true, context)
        
        sportsList.createNewItem(name: "Laptop", isImportant: true, order: 0, context)
        sportsList.createNewItem(name: "Pen", order: 1, context)
        sportsList.createNewItem(name: "Pocket Book", order: 2, context)
        sportsList.createNewItem(name: "Documents", order: 3, context)
        sportsList.createNewItem(name: "Watch", order: 4, context)
        sportsList.createNewRepeatNotification(weekdays: "0", time: Notification.defaultDate, context)
        sportsList.createNewRepeatNotification(weekdays: "36", time: Date(), context)
        
        let domesticTravelList = listsFolder.createNewItemList(name: "Domestic Travel", color: K.colors.basic.pink, iconName: "Suit Case", image: "suitcase", order: 7, notificationIsActive: true, context)
        
        domesticTravelList.createNewItem(name: "Laptop", isImportant: true, order: 0, context)
        domesticTravelList.createNewItem(name: "Pen", order: 1, context)
        domesticTravelList.createNewItem(name: "Pocket Book", order: 2, context)
        domesticTravelList.createNewItem(name: "Documents", order: 3, context)
        domesticTravelList.createNewItem(name: "Watch", order: 4, context)
        domesticTravelList.createNewRepeatNotification(weekdays: "0", time: Notification.defaultDate, context)
        domesticTravelList.createNewRepeatNotification(weekdays: "36", time: Date(), context)
        
        let overseasTravelList = listsFolder.createNewItemList(name: "Overseas Travel", color: K.colors.basic.red, iconName: "Airplane", image: "airplane", order: 8, notificationIsActive: true, context)
        
        overseasTravelList.createNewItem(name: "Laptop", isImportant: true, order: 0, context)
        overseasTravelList.createNewItem(name: "Pen", order: 1, context)
        overseasTravelList.createNewItem(name: "Pocket Book", order: 2, context)
        overseasTravelList.createNewItem(name: "Documents", order: 3, context)
        overseasTravelList.createNewItem(name: "Watch", order: 4, context)
        overseasTravelList.createNewRepeatNotification(weekdays: "0", time: Notification.defaultDate, context)
        overseasTravelList.createNewRepeatNotification(weekdays: "36", time: Date(), context)
        
        let favoriteFolder = createNewFolder(name: K.defaultName.favorite, image: "star", order: 1, context)
        
        do {
            try context.save()
            print("Saved")
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return [favoriteFolder, listsFolder]
    }
    
    private static func saveData(_ context: NSManagedObjectContext) {
        do {
            try context.save()
            print("Saved")
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}
