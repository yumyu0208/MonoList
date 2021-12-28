//
//  Folder+CoreDataClass.swift
//  MonoList
//
//  Created by 竹田悠真 on 2021/12/28.
//
//

import SwiftUI
import CoreData

@objc(Folder)
public class Folder: NSManagedObject {
    
    @Environment(\.managedObjectContext) private static var viewContext
    
    @discardableResult
    static func createNewFolder(name: String, image: String = "folder") -> Folder {
        let newFolder = Folder(context: viewContext)
        newFolder.name = name
        newFolder.image = image
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return newFolder
    }
    
    @discardableResult
    func addItemList(name: String = "default_newList", color: String = K.listColors.basic.green, image: String = "checklist") -> ItemList {
        return ItemList.createNewItemList(name: name, color: color, image: image, for: self)
    }
}
