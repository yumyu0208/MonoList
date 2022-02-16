//
//  Item+CoreDataClass.swift
//  MonoList
//
//  Created by 竹田悠真 on 2022/01/21.
//
//

import Foundation
import CoreData


public class Item: NSManagedObject {
    func duplicate(for itemList: ItemList, _ context: NSManagedObjectContext) {
        itemList.createNewItem(
            name: name,
            weight: weight,
            quantity: Int(quantity),
            isImportant: isImportant,
            note: note,
            image: image,
            conditions: conditions,
            photo: photo,
            category: category,
            order: Int(order),
            context)
    }
    
    func data() -> ItemData {
        return ItemData(conditions: conditions,
                        id: id,
                        image: image,
                        isCompleted: isCompleted,
                        isImportant: isImportant,
                        name: name,
                        note: note,
                        order: Int(order),
                        quantity: Int(quantity),
                        weight: weight,
                        categoryData: category?.data())
    }
}
