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
    
    @Environment(\.managedObjectContext) private static var viewContext
    
    @discardableResult
    static func createNewFolder(name: String, image: String = "folder") -> Folder {
        let newFolder = Folder(context: viewContext)
        newFolder.name = name
        newFolder.image = image
        return newFolder
    }
    
    @discardableResult
    func addItemList(name: String = "default_newList", color: String = K.listColors.basic.green, image: String = "checklist") -> ItemList {
        let newItemList = ItemList.createNewItemList(name: name, color: color, image: image)
        addToItemLists(newItemList)
        do {
            try Self.viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return newItemList
    }
}
