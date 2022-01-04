//
//  ItemListView.swift
//  MonoList
//
//  Created by 竹田悠真 on 2022/01/04.
//

import SwiftUI

struct EditItemListView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) var dismiss
    @FetchRequest var items: FetchedResults<Item>
    
    var itemList: ItemList?
    
    init(of itemList: ItemList) {
        self.itemList = itemList
        _items = FetchRequest(
            sortDescriptors: [
                SortDescriptor(\.order, order: .forward)
            ],
            predicate: NSPredicate(format: "parentItemList == %@", itemList)
        )
    }
    
    var body: some View {
        List {
            ForEach(items) { item in
                Text(item.name)
            }
        }
        .navigationTitle(itemList!.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                }
                .buttonStyle(CircleButton(type: .cancel))
            }
        }
        .onDisappear {
            if let itemList = itemList,
                itemList.name == K.defaultName.newItemList {
                withAnimation {
                    viewContext.delete(itemList)
                    saveData()
                }
            }
        }
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

struct EditItemListView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        let itemList = MonoListManager().fetchItemLists(context: context)[0]
        EditItemListView(of: itemList)
            .environment(\.managedObjectContext, context)
    }
}
