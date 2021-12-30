//
//  MonoListManager.swift
//  MonoList
//
//  Created by 竹田悠真 on 2021/12/30.
//

import SwiftUI
import CoreData

struct MonoListManager {
    
    private func saveData(_ context: NSManagedObjectContext) {
        do {
            try context.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    @discardableResult
    private func createNewFolder(name: String, image: String, _ context: NSManagedObjectContext) -> Folder {
        let newFolder = Folder(context: context)
        newFolder.name = name
        newFolder.image = image
        return newFolder
    }
    
    @discardableResult
    func addFolder(name: String = "default_newFolder", image: String = "folder", _ context: NSManagedObjectContext) -> Folder {
        let newFolder = createNewFolder(name: name, image: image, context)
        saveData(context)
        return newFolder
    }
    
}
