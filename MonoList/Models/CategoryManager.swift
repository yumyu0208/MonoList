//
//  CategoryManager.swift
//  MonoList
//
//  Created by 竹田悠真 on 2022/01/22.
//

import Foundation
import CoreData

class CategoryManager {
    
    @discardableResult
    func createNewCategory(name: String, image: String, _ context: NSManagedObjectContext) -> Category {
        let newCategory = Category(context: context)
        newCategory.id = UUID()
        newCategory.name = name
        newCategory.image = image
        return newCategory
    }
}
