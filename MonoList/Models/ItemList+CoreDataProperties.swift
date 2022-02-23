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
    @NSManaged public var categoryIsHidden: Bool
    @NSManaged public var color: String
    @NSManaged public var creationDate: Date
    @NSManaged public var displayFormat: String
    @NSManaged public var hideCompleted: Bool
    @NSManaged public var iconName: String
    @NSManaged public var id: UUID
    @NSManaged public var image: String
    @NSManaged public var notificationIsActive: Bool
    @NSManaged public var name: String
    @NSManaged public var order: Int32
    @NSManaged public var primaryColor: String?
    @NSManaged public var quantityIsHidden: Bool
    @NSManaged public var secondaryColor: String?
    @NSManaged public var tertiaryColor: String?
    @NSManaged public var type: String
    @NSManaged public var unitLabel: String
    @NSManaged public var updateDate: Date
    @NSManaged public var weightIsHidden: Bool
    @NSManaged public var items: NSSet?
    @NSManaged public var notifications: NSSet?
    @NSManaged public var parentFolder: Folder

}

// MARK: Generated accessors for items
extension ItemList {

    @objc(addItemsObject:)
    @NSManaged public func addToItems(_ value: Item)

    @objc(removeItemsObject:)
    @NSManaged public func removeFromItems(_ value: Item)

    @objc(addItems:)
    @NSManaged public func addToItems(_ values: NSSet)

    @objc(removeItems:)
    @NSManaged public func removeFromItems(_ values: NSSet)

}

// MARK: Generated accessors for notifications
extension ItemList {

    @objc(addNotificationsObject:)
    @NSManaged public func addToNotifications(_ value: Notification)

    @objc(removeNotificationsObject:)
    @NSManaged public func removeFromNotifications(_ value: Notification)

    @objc(addNotifications:)
    @NSManaged public func addToNotifications(_ values: NSSet)

    @objc(removeNotifications:)
    @NSManaged public func removeFromNotifications(_ values: NSSet)

}

extension ItemList : Identifiable {

}
