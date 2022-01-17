//
//  CheckListView.swift
//  MonoList
//
//  Created by 竹田悠真 on 2022/01/14.
//

import SwiftUI

struct CheckListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    let itemList: ItemList
    @FetchRequest var items: FetchedResults<Item>
    
    init(of itemList: ItemList, showCompleted: Bool) {
        self.itemList = itemList
        
        let predicateFormat = showCompleted ? "parentItemList == %@" : "parentItemList == %@ && isCompleted == NO"
        
        _items = FetchRequest(
            sortDescriptors: [
                SortDescriptor(\.order, order: .forward)
            ],
            predicate: NSPredicate(format: predicateFormat, itemList),
            animation: .default.delay(0.3)
        )
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                ForEach(items) { item in
                    CheckItemCell(item: item)
                } //: VStack
            } //: VStack
            .padding()
        } //: ScrollView
    }
    
    private func saveData() {
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}

struct CheckListView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        let itemList = MonoListManager().fetchItemLists(context: context)[0]
        CheckListView(of: itemList, showCompleted: true)
            .environment(\.managedObjectContext, context)
    }
}
