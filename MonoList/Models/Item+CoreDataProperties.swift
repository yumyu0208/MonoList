//
//  Item+CoreDataProperties.swift
//  MonoList
//
//  Created by 竹田悠真 on 2021/12/28.
//
//

import Foundation
import CoreData


extension Item {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Item> {
        return NSFetchRequest<Item>(entityName: "Item")
    }

    @NSManaged public var category: String?
    @NSManaged public var conditions: String?
    @NSManaged public var id: UUID
    @NSManaged public var image: String?
    @NSManaged public var isImportant: Bool
    @NSManaged public var name: String
    @NSManaged public var note: String?
    @NSManaged public var order: Int32
    @NSManaged public var quantity: Int32
    @NSManaged public var state: String
    @NSManaged public var weight: Double
    @NSManaged public var parentItemList: ItemList

}

extension Item : Identifiable {

}
