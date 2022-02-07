//
//  ItemData.swift
//  MonoList
//
//  Created by 竹田悠真 on 2022/02/07.
//

import Foundation
import CoreData

struct ItemData: Codable {
    var conditions: String?
    var id: UUID
    var image: String?
    var isCompleted: Bool
    var isImportant: Bool
    var name: String
    var note: String?
    var order: Int
    var quantity: Int
    var weight: Double
    var categoryData: CategoryData?
    
    func createItem(context: NSManagedObjectContext) -> Item {
        let item = Item(context: context)
        item.conditions = conditions
        item.id = id
        item.image = image
        item.isCompleted = isCompleted
        item.isImportant = isImportant
        item.name = name
        item.note = note
        item.order = Int32(order)
        item.quantity = Int32(quantity)
        item.weight = weight
        let categories = CategoryManager().fetchAllCategories(context)
        if let category = categories.first(where: { $0.name == categoryData?.name }) {
            item.category = category
        } else {
            item.category = categoryData?.createCategory(order: categories.count, context: context)
        }
        return item
    }
}
