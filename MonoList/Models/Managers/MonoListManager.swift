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
