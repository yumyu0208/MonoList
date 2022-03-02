//
//  ItemList+CoreDataClass.swift
//  MonoList
//
//  Created by 竹田悠真 on 2021/12/28.
//
//

import SwiftUI
import CoreData


public class ItemList: NSManagedObject {
    
    enum Form: String {
        case list = "List"
        case gallery = "1 Line Gallery"
        case gallery2 = "2 Line Gallery"
        case gallery3 = "3 Line Gallery"
    }
    
    static var allForms: [Form] {
        [.list, .gallery, .gallery2, .gallery3]
    }
    
    var form: Form {
        get {
            switch displayFormat {
            case Form.list.rawValue:
                return .list
            case Form.gallery.rawValue:
                return .gallery
            case Form.gallery2.rawValue:
                return .gallery2
            case Form.gallery3.rawValue:
                return .gallery3
            default:
                return .list
            }
        }
        set {
            displayFormat = newValue.rawValue
        }
    }
    
    var isNew: Bool {
        name == K.defaultName.newItemList
    }
    
    var sortedItems: [Item] {
        (items?.allObjects as? [Item] ?? []).sorted(by: { $0.order < $1.order })
    }
    
    var achievementCountString: String {
        String(achievementCount)
    }
    
    var numberOfItemsString: String {
        String(items?.count ?? 0)
    }
    
    var numberOfCompletedItemsString: String {
        guard let items = items?.allObjects as? [Item] else { return "0" }
        return String(items.filter { $0.isCompleted }.count)
    }
    
    var hasItems: Bool {
        (items?.count ?? 0) != 0
    }
    
    var hasNotifications: Bool {
        (notifications?.count ?? 0) != 0
    }
    
    var creationDateString: String {
        string(from: creationDate)
    }
    
    var lastModifiedDateString: String {
        string(from: updateDate)
    }
    
    var notificationIdentifiers: [String] {
        guard let notifications = notifications?.allObjects as? [Notification] else { return [] }
        return notifications.map { $0.id.uuidString }
    }
    
    var stateId: String {
        let unit = unitLabel
        let category = categoryIsHidden ? "t" : "f"
        let quantity = quantityIsHidden ? "t" : "f"
        let weight = weightIsHidden ? "t" : "f"
        return "\(unit)\(category)\(quantity)\(weight)"
    }
    
    typealias ChartData = (values: [Double], names: [String], images: [String], colors: [Color])
    
    func weightChartData(_ context: NSManagedObjectContext) -> ChartData? {
        let categories = CategoryManager().fetchAllCategories(context).sorted { $0.order < $1.order }
        let allItems = items?.allObjects as! [Item]
        let itemsWithNoCategory = allItems.filter { $0.category == nil }
        let itemsWithCategory = allItems.filter { $0.category != nil }
        
        let weightValuesOfNoCategory = itemsWithNoCategory.map { $0.weight * Double($0.quantity) }
        let totalValueOfNoCategory = weightValuesOfNoCategory.reduce(0, +)
        
        let categoriesAndTotalValues = (categories.map { category -> (category: Category?, totalValue: Double) in
            let itemsInCategory = itemsWithCategory.filter { $0.category == category }
            let weightValues = itemsInCategory.map { $0.weight * Double($0.quantity) }
            let totalValue = weightValues.reduce(0, +)
            return (category, totalValue)
        } + [(nil, totalValueOfNoCategory)]).filter { $0.totalValue > 0 }.sorted { $0.totalValue > $1.totalValue }
        
        guard !categoriesAndTotalValues.isEmpty else { return nil }
        
        let totalValues = categoriesAndTotalValues.map { $0.totalValue }
        let names = categoriesAndTotalValues.map { $0.category?.name ?? "Uncategorized" }
        let images = categoriesAndTotalValues.map { $0.category?.image ?? "tag.slash" }
        let colors = categoriesAndTotalValues.enumerated().map { index, _ -> Color in
            let numberOfAll = categoriesAndTotalValues.count
            guard let listColor = UIColor(named: color),
                  let lightStandardColor = listColor.lighter(by: 0.0),
                  let uiColor = lightStandardColor.darker(by: CGFloat(index)/CGFloat(numberOfAll) * 0.5)
            else { return .clear }
            return Color(uiColor)
        }
        return (totalValues, names, images, colors)
    }
    
    func string(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.locale = Locale.current
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        return dateFormatter.string(from: date)
    }
    
    static func delete(index: Int, itemLists: FetchedResults<ItemList>, _ context: NSManagedObjectContext) {
        // Delete All Items
        if let items = itemLists[index].items?.allObjects as? [Item] {
            items.forEach { item in
                context.delete(item)
            }
        }
        // Delete All Notifications
        if let notifications = itemLists[index].notifications?.allObjects as? [Notification] {
            notifications.forEach { notification in
                NotificationManager().deletePendingNotificationRequests([notification])
                context.delete(notification)
            }
        }
        // Delete All Histories
        // ...
        
        context.delete(itemLists[index])
        if index != itemLists.count-1 {
            for index in index+1 ... itemLists.count-1 {
                itemLists[index].order -= 1
            }
        }
    }
    
    func duplicate(_ context: NSManagedObjectContext) {
        let duplicatedItemList = parentFolder.createNewItemList(
            name: name + " " + "Copied".localized,
            color: color,
            primaryColor: primaryColor,
            secondaryColor: secondaryColor,
            tertiaryColor: tertiaryColor,
            iconName: iconName,
            image: image,
            achievementCount: 0,
            displayFormat: displayFormat,
            hideCompleted: hideCompleted,
            creationDate: Date(),
            updateDate: Date(),
            order: Int(order) + 1,
            type: type,
            unitLabel: unitLabel,
            categoryIsHidden: categoryIsHidden,
            weightIsHidden: weightIsHidden,
            quantityIsHidden: quantityIsHidden,
            context)
        (items?.allObjects as? [Item])?.forEach({ item in
            item.duplicate(for: duplicatedItemList, context)
        })
    }
    
    @discardableResult
    func createNewItem(name: String, weight: Double? = nil, quantity: Int? = nil, isCompleted: Bool = false, isImportant: Bool = false, note: String? = nil, image: String? = nil, conditions: String? = nil, photo: Data? = nil, category: Category? = nil, order: Int, _ context: NSManagedObjectContext) -> Item {
        let newItem = Item(context: context)
        newItem.id = UUID()
        newItem.name = name
        newItem.quantity = quantity != nil ? Int32(quantity!) : 1
        newItem.weight = weight ?? 0
        newItem.isCompleted = isCompleted
        newItem.isImportant = isImportant
        newItem.note = note
        newItem.image = image
        newItem.conditions = conditions
        newItem.photo = photo
        newItem.order = Int32(order)
        newItem.category = category
        addToItems(newItem)
        return newItem
    }
    
    enum Order {
        case important
        case category
        case heavy
        case light
        case many
        case few
    }
    
    func orderItems() {
        guard let items = items?.allObjects as? [Item] else { return }
        let orderedItems = items.sorted { $0.order < $1.order }
        var count: Int32 = 0
        for item in orderedItems {
            if item.order != count {
                item.order = count
            }
            count += 1
        }
    }
    
    func sortItems(order: Order) {
        guard let items = items?.allObjects as? [Item] else { return }
        var sortedItems: [Item]?
        switch order {
        case .important:
            sortedItems = items.sorted { lhs, rhs in
                if lhs.isImportant == rhs.isImportant {
                    return lhs.order < rhs.order
                } else {
                    return lhs.isImportant
                }
            }
        case .category:
            sortedItems = items.sorted { lhs, rhs in
                if lhs.category == nil && rhs.category == nil {
                    return lhs.order < rhs.order
                } else if lhs.category == nil || rhs.category == nil {
                    return lhs.category != nil
                } else {
                    if lhs.category == rhs.category {
                        return lhs.order < rhs.order
                    } else {
                        return lhs.category!.order < rhs.category!.order
                    }
                }
            }
        case .heavy:
            sortedItems = items.sorted { lhs, rhs in
                if lhs.weight == rhs.weight {
                    return lhs.order < rhs.order
                } else {
                    return lhs.weight > rhs.weight
                }
            }
        case .light:
            sortedItems = items.sorted { lhs, rhs in
                if lhs.weight == rhs.weight {
                    return lhs.order < rhs.order
                } else {
                    return lhs.weight < rhs.weight
                }
            }
        case .many:
            sortedItems = items.sorted { lhs, rhs in
                if lhs.quantity == rhs.quantity {
                    return lhs.order < rhs.order
                } else {
                    return lhs.quantity > rhs.quantity
                }
            }
        case .few:
            sortedItems = items.sorted { lhs, rhs in
                if lhs.quantity == rhs.quantity {
                    return lhs.order < rhs.order
                } else {
                    return lhs.quantity < rhs.quantity
                }
            }
        }
        guard let sortedItems = sortedItems else { return }
        var count: Int32 = 0
        for item in sortedItems {
            item.order = count
            count += 1
        }
    }
    
    @discardableResult
    func createNewRepeatNotification(weekdays: String, time: Date, _ context: NSManagedObjectContext) -> Notification {
        let newNotification = Notification(context: context)
        newNotification.creationDate = Date()
        newNotification.id = UUID()
        newNotification.weekdays = weekdays
        newNotification.time = time
        addToNotifications(newNotification)
        return newNotification
    }
    
    @discardableResult
    func createNewSpecificDateAndTimeNotification(time: Date, _ context: NSManagedObjectContext) -> Notification {
        let newNotification = Notification(context: context)
        newNotification.creationDate = Date()
        newNotification.id = UUID()
        newNotification.weekdays = ""
        newNotification.time = time
        addToNotifications(newNotification)
        return newNotification
    }
    
    
    func data() -> ItemListData {
        var itemDataArray: [ItemData]?
        if let items = items?.allObjects as? [Item] {
            itemDataArray = items.map { $0.data() }
        }
        var notificationDataArray: [NotificationData]?
        if let notifications = notifications?.allObjects as? [Notification] {
            notificationDataArray = notifications.map { $0.data() }
        }
        return ItemListData(achievementCount: Int(achievementCount),
                            color: color,
                            creationDate: creationDate,
                            displayFormat: displayFormat,
                            hideCompleted: hideCompleted,
                            iconName: iconName,
                            id: id,
                            image: image,
                            notificationIsActive: notificationIsActive,
                            name: name,
                            order: Int(order),
                            primaryColor: primaryColor,
                            secondaryColor: secondaryColor,
                            tertiaryColor: tertiaryColor,
                            type: type,
                            unitLabel: unitLabel,
                            updateDate: updateDate,
                            categoryIsHidden: categoryIsHidden,
                            weightIsHidden: weightIsHidden,
                            quantityIsHidden: quantityIsHidden,
                            itemDataArray: itemDataArray,
                            notificationDataArray: notificationDataArray)
    }
}
