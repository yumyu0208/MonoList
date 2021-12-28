//
//  ItemList+CoreDataProperties.swift
//  MonoList
//
//  Created by 竹田悠真 on 2021/12/28.
//
//

import Foundation
import CoreData


extension ItemList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ItemList> {
        return NSFetchRequest<ItemList>(entityName: "ItemList")
    }

    @NSManaged public var achievementCount: Int32
    @NSManaged public var color: String
    @NSManaged public var creationDate: Date
    @NSManaged public var displayFormat: String
    @NSManaged public var id: UUID
    @NSManaged public var image: String
    @NSManaged public var name: String
    @NSManaged public var type: String
    @NSManaged public var updateDate: Date
    @NSManaged public var items: Item?
    @NSManaged public var notifications: Notification?
    @NSManaged public var parentFolder: Folder?

}

extension ItemList : Identifiable {

}
