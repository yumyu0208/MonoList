//
//  Category+CoreDataClass.swift
//  MonoList
//
//  Created by 竹田悠真 on 2022/01/21.
//
//

import SwiftUI
import CoreData

@objc(Category)
public class Category: NSManagedObject {
    
    var isNew: Bool {
        name == K.defaultName.newCategory
    }
    
    static func delete(index: Int, categories: FetchedResults<Category>, _ context: NSManagedObjectContext) {
        context.delete(categories[index])
        if index != categories.count-1 {
            for index in index+1 ... categories.count-1 {
                categories[index].order -= 1
            }
        }
    }
    
    func data() -> CategoryData {
        CategoryData(id: id,
                     name: name,
                     image: image)
    }
}
