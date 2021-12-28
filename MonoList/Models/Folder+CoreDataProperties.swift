//
//  Folder+CoreDataProperties.swift
//  MonoList
//
//  Created by 竹田悠真 on 2021/12/28.
//
//

import Foundation
import CoreData


extension Folder {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Folder> {
        return NSFetchRequest<Folder>(entityName: "Folder")
    }

    @NSManaged public var image: String
    @NSManaged public var name: String
    @NSManaged public var order: Int32
    @NSManaged public var itemLists: NSSet?

}

// MARK: Generated accessors for itemLists
extension Folder {

    @objc(addItemListsObject:)
    @NSManaged public func addToItemLists(_ value: ItemList)

    @objc(removeItemListsObject:)
    @NSManaged public func removeFromItemLists(_ value: ItemList)

    @objc(addItemLists:)
    @NSManaged public func addToItemLists(_ values: NSSet)

    @objc(removeItemLists:)
    @NSManaged public func removeFromItemLists(_ values: NSSet)

}

extension Folder : Identifiable {

}
