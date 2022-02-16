//
//  Item+CoreDataProperties.swift
//  MonoList
//
//  Created by 竹田悠真 on 2022/01/21.
//
//

import Foundation
import CoreData


extension Item {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Item> {
        return NSFetchRequest<Item>(entityName: "Item")
    }

    @NSManaged public var conditions: String?
    @NSManaged public var id: UUID
    @NSManaged public var image: String?
    @NSManaged public var isCompleted: Bool
    @NSManaged public var isImportant: Bool
    @NSManaged public var name: String
    @NSManaged public var note: String?
    @NSManaged public var order: Int32
    @NSManaged public var quantity: Int32
    @NSManaged public var weight: Double
    @NSManaged public var photo: Data?
    @NSManaged public var parentItemList: ItemList
    @NSManaged public var category: Category?

}

extension Item : Identifiable {

}
