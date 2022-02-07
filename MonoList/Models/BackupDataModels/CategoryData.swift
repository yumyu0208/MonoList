//
//  CategoryData.swift
//  MonoList
//
//  Created by 竹田悠真 on 2022/02/07.
//

import Foundation
import CoreData

struct CategoryData: Codable {
    var id: UUID
    var name: String
    var image: String?
    
    func createCategory(order: Int, context: NSManagedObjectContext) -> Category {
        let category = Category(context: context)
        category.id = id
        category.name = name
        category.image = image
        category.order = Int32(order)
        return category
    }
}
