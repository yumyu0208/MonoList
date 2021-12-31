//
//  MonoListManager.swift
//  MonoList
//
//  Created by 竹田悠真 on 2021/12/30.
//

import SwiftUI
import CoreData

struct MonoListManager {
    
    @discardableResult
    private func createNewFolder(name: String, image: String, order: Int, _ context: NSManagedObjectContext) -> Folder {
        let newFolder = Folder(context: context)
        newFolder.name = name
        newFolder.image = image
        newFolder.order = Int32(order)
        return newFolder
    }
    
    @discardableResult
    func addFolder(name: String = "default_newFolder", image: String = "folder", order: Int, _ context: NSManagedObjectContext) -> Folder {
        let newFolder = createNewFolder(name: name, image: image, order: order, context)
        return newFolder
    }
    
}
