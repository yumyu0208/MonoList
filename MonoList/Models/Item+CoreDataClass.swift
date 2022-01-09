//
//  Item+CoreDataClass.swift
//  MonoList
//
//  Created by 竹田悠真 on 2021/12/28.
//
//

import SwiftUI
import CoreData


public class Item: NSManagedObject {
    
    func duplicate(for itemList: ItemList, _ context: NSManagedObjectContext) {
        itemList.createNewItem(
            name: name,
            category: category,
            weight: weight,
            quantity: Int(quantity),
            isImportant: isImportant,
            note: note,
            image: image,
            conditions: conditions,
            order: Int(order),
            context)
    }
}
