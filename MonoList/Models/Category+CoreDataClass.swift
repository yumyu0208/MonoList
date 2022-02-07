//
//  Category+CoreDataClass.swift
//  MonoList
//
//  Created by 竹田悠真 on 2022/01/21.
//
//

import Foundation
import CoreData

@objc(Category)
public class Category: NSManagedObject {
    func data() -> CategoryData {
        CategoryData(id: id,
                     name: name,
                     image: image)
    }
}
