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
        ScrollView {
            LazyVStack {
                ForEach(items) { item in
                    let isComplete = (item.state == K.state.complete)
                    VStack {
                        HStack(alignment: .center) {
                            Button {
                                item.state = isComplete ? K.state.incomplete : K.state.complete
                                saveData()
                            } label: {
                                ZStack {
                                    Image(systemName: "square")
                                        .imageScale(.large)
                                        .foregroundColor(.primary)
                                    Image(systemName: "checkmark")
                                        .imageScale(.small)
                                        .foregroundColor(.accentColor)
                                        .opacity(isComplete ? 1 : 0)
                                        .animation(.easeOut(duration: 0.2), value: isComplete)
                                }
                            }
                            Text(item.name)
                            Spacer()
                        } //: HStack
                        .font(.title3)
                        .padding(.horizontal)
                        .padding(.vertical, 4)
                        Rectangle()
                            .frame(height: 1)
                            .foregroundColor(.primary)
                    } //: VStack
                } //: VStack
            } //: LazyVStack
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
        CheckListView(of: itemList)
            .environment(\.managedObjectContext, context)
    }
}
