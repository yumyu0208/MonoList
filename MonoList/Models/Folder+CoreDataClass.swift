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
    
    @discardableResult
    func createNewItemList(name: String, color: String, image: String, achievementCount: Int = 0, displayFormat: String = "list", creationDate: Date = Date(), updateDate: Date = Date(), order: Int, type: String = "belongings", _ context: NSManagedObjectContext) -> ItemList {
        let newItemList = ItemList(context: context)
        newItemList.id = UUID()
        newItemList.name = name
        newItemList.color = color
        newItemList.image = image
        newItemList.achievementCount = Int32(achievementCount)
        newItemList.displayFormat = displayFormat
        newItemList.creationDate = creationDate
        newItemList.updateDate = updateDate
        newItemList.order = Int32(order)
        newItemList.type = type
        addToItemLists(newItemList)
        return newItemList
    }
}
