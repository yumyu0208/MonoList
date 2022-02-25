//
//  FolderData.swift
//  MonoList
//
//  Created by 竹田悠真 on 2022/02/07.
//

import Foundation
import CoreData

struct FolderData: Codable {
    var image: String
    var name: String
    var order: Int
    var itemListDataArray: [ItemListData]?
    
    func createFolder(context: NSManagedObjectContext) {
        let folder = Folder(context: context)
        folder.image = image
        folder.name = name
        folder.order = Int32(order)
        if let itemListDataArray = itemListDataArray?.sorted(by: { $0.order < $1.order }) {
            for itemListData in itemListDataArray {
                folder.addToItemLists(itemListData.createItemList(context: context))
            }
        }
    }
}
