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
    
    @discardableResult
    func createSamples(context: NSManagedObjectContext) -> [Folder] {
        let favoriteFolder = createNewFolder(name: K.defaultName.favorite, image: "star", order: 0, context)
        let workList = favoriteFolder.createNewItemList(name: "Work", color: K.listColors.basic.blue, image: "briefcase", order: 0, context)
        
//        workList.addItem(name: "Laptop")
//        workList.addItem(name: "Pen")
//        workList.addItem(name: "Pocket Book")
//        workList.addItem(name: "Documents")
//        workList.addItem(name: "Watch")
//        let shoppingList = favoriteFolder.addItemList(name: "Shopping", color: K.listColors.basic.yellow, image: "cart")
//        shoppingList.addItem(name: "Laptop")
//        shoppingList.addItem(name: "Pen")
//        shoppingList.addItem(name: "Pocket Book")
//        shoppingList.addItem(name: "Documents")
//        shoppingList.addItem(name: "Watch")
        let collegeList = favoriteFolder.createNewItemList(name: "College", color: K.listColors.basic.green, image: "graduationcap", order: 1, context)
//        collegeList.addItem(name: "Laptop")
//        collegeList.addItem(name: "Pen")
//        collegeList.addItem(name: "Pocket Book")
//        collegeList.addItem(name: "Documents")
//        collegeList.addItem(name: "Watch")
        let listsFolder = createNewFolder(name: K.defaultName.lists, image: "checklist", order: 1, context)
//        let driveList = listsFolder.addItemList(name: "Drive", color: K.listColors.basic.lightBlue, image: "car")
//        driveList.addItem(name: "Laptop")
//        driveList.addItem(name: "Pen")
//        driveList.addItem(name: "Pocket Book")
//        driveList.addItem(name: "Documents")
//        driveList.addItem(name: "Watch")
//        let campList = listsFolder.addItemList(name: "Camp", color: K.listColors.basic.orange, image: "flame")
//        campList.addItem(name: "Laptop")
//        campList.addItem(name: "Pen")
//        campList.addItem(name: "Pocket Book")
//        campList.addItem(name: "Documents")
//        campList.addItem(name: "Watch")
//        let fishingList = listsFolder.addItemList(name: "Fishing", color: K.listColors.basic.gray, image: "ferry")
//        fishingList.addItem(name: "Laptop")
//        fishingList.addItem(name: "Pen")
//        fishingList.addItem(name: "Pocket Book")
//        fishingList.addItem(name: "Documents")
//        fishingList.addItem(name: "Watch")
//        let sportsList = listsFolder.addItemList(name: "Sports", color: K.listColors.basic.purple, image: "sportscourt")
//        sportsList.addItem(name: "Laptop")
//        sportsList.addItem(name: "Pen")
//        sportsList.addItem(name: "Pocket Book")
//        sportsList.addItem(name: "Documents")
//        sportsList.addItem(name: "Watch")
//        let domesticTravelList = listsFolder.addItemList(name: "Domestic Travel", color: K.listColors.basic.pink, image: "suitcase")
//        domesticTravelList.addItem(name: "Laptop")
//        domesticTravelList.addItem(name: "Pen")
//        domesticTravelList.addItem(name: "Pocket Book")
//        domesticTravelList.addItem(name: "Documents")
//        domesticTravelList.addItem(name: "Watch")
//        let overseasTravelList = listsFolder.addItemList(name: "Overseas Travel", color: K.listColors.basic.red, image: "airplane")
//        overseasTravelList.addItem(name: "Laptop")
//        overseasTravelList.addItem(name: "Pen")
//        overseasTravelList.addItem(name: "Pocket Book")
//        overseasTravelList.addItem(name: "Documents")
//        overseasTravelList.addItem(name: "Watch")
        do {
            try context.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return [favoriteFolder, listsFolder]
    }
}
