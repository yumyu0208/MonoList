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
    static func createNewCategory(name: String, image: String, order: Int, _ context: NSManagedObjectContext) -> Category {
        let newCategory = Category(context: context)
        newCategory.id = UUID()
        newCategory.name = name
        newCategory.image = image
        newCategory.order = Int32(order)
        return newCategory
    }
    
    func fetchAllCategories(_ context: NSManagedObjectContext) -> [Category] {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Category")
        let sortDescriptor = NSSortDescriptor(key: "order", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        do {
            let categories = try context.fetch(request) as! [Category]
            return categories
        }
        catch {
            fatalError("Failed to fetch all categories")
        }
    }
    
    func orderCategory(context: NSManagedObjectContext) {
        let categories = fetchAllCategories(context)
        let orderedCategories = categories.sorted { $0.order < $1.order }
        var count: Int32 = 0
        for category in orderedCategories {
            if category.order != count {
                category.order = count
            }
            count += 1
        }
    }
}
