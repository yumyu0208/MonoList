//
//  ItemListView.swift
//  MonoList
//
//  Created by 竹田悠真 on 2022/01/04.
//

import SwiftUI

struct ItemListView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
    
    private func saveData() {
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
//    @discardableResult
//    func addItem(name: String, order: Int) -> Item {
//        let newItem = createNewItem(name: name, order: order, viewContext)
//        saveData()
//        return newItem
//    }
//    
//    @discardableResult
//    func addNotification(weekdays: [String], time: Date) -> Notification {
//        let newNotification = createNewNotification(weekdays: weekdays, time: time, viewContext)
//        saveData()
//        return newNotification
//    }
    
}

struct ItemListView_Previews: PreviewProvider {
    static var previews: some View {
        ItemListView()
    }
}
