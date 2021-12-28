//
//  Notification+CoreDataProperties.swift
//  MonoList
//
//  Created by 竹田悠真 on 2021/12/28.
//
//

import Foundation
import CoreData


extension Notification {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Notification> {
        return NSFetchRequest<Notification>(entityName: "Notification")
    }

    @NSManaged public var time: Date
    @NSManaged public var weekdays: String
    @NSManaged public var parentItemList: ItemList?

}

extension Notification : Identifiable {

}
