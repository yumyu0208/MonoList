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
    @NSManaged public var itemLists: ItemList?

}

extension Folder : Identifiable {

}
