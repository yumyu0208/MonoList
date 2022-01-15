//
//  ItemListView.swift
//  MonoList
//
//  Created by 竹田悠真 on 2022/01/04.
//

import SwiftUI

struct EditItemListView: View {
    @Environment(\.editMode) private var editMode
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest var items: FetchedResults<Item>
    
    var itemList: ItemList?
    
    var listNameTextFieldIsFocused: FocusState<Bool>.Binding
    var focusedItem: FocusState<Focusable?>.Binding
    var isEditing: Bool {
        editMode?.wrappedValue == .active
    }
    
    init(of itemList: ItemList, listNameTextFieldIsFocused: FocusState<Bool>.Binding, focusedItem: FocusState<Focusable?>.Binding) {
        self.itemList = itemList
        
        _items = FetchRequest(
            sortDescriptors: [
                SortDescriptor(\.order, order: .forward)
            ],
            predicate: NSPredicate(format: "parentItemList == %@", itemList)
        )
        self.focusedItem = focusedItem
        self.listNameTextFieldIsFocused = listNameTextFieldIsFocused
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                ScrollViewReader { proxy in
                    List {
                        Section {
                            ForEach(items) { item in
                                EditItemCellView(item: item,
                                                 focusedItem: focusedItem,
                                deleteAction: { item in
                                    if let index = items.firstIndex(of: item) {
                                        let isLastItem = (index == items.count-1)
                                        deleteItems(offsets: IndexSet(integer: index), animation: isLastItem ? .none : .default)
                                    }
                                }, addAction: { item in
                                    focusedItem.wrappedValue = .row(id: item.id.uuidString)
                                    if let index = items.firstIndex(of: item) {
                                        withAnimation {
                                            let newItem = addItem(name: "", order: index+1)
                                            focusedItem.wrappedValue = .row(id: newItem.id.uuidString)
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                                withAnimation {
                                                    proxy.scrollTo(newItem, anchor: .bottom)
                                                }
                                            }
                                        }
                                    }
                                })
                                    .listRowSeparator(.visible)
                                    .disabled(isEditing)
                                    .swipeActions(edge: .trailing) {
                                        Button(role: .destructive) {
                                            if let index = items.firstIndex(of: item) {
                                                deleteItems(offsets: IndexSet(integer: index))
                                            }
                                        } label: {
                                            Label("Delete", systemImage: "trash")
                                        }
                                    }
                                    .swipeActions(edge: .leading) {
                                        Button {
                                            withAnimation {
                                                item.isImportant.toggle()
                                            }
                                        } label: {
                                            Label("Frag", systemImage: "exclamationmark")
                                        }
                                        .tint(.orange)
                                    }
                                    .id(item)
                            }
                            .onDelete(perform: { indexSet in
                                deleteItems(offsets: indexSet)
                            })
                            .onMove(perform: moveitem)
                            Rectangle()
                                .frame(height: 36)
                                .foregroundColor(.clear)
                                .listRowSeparator(.hidden, edges: items.isEmpty ? .all : .bottom)
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    withAnimation {
                                        let newItem = addItem(name: "", order: items.count)
                                        focusedItem.wrappedValue = .row(id: newItem.id.uuidString)
                                    }
                                }
                        } header: {
                            HStack {
                                Spacer()
                                HStack(spacing: 12) {
                                    EditButtonView()
                                        .environment(\.editMode, editMode)
                                    Button {
                                        withAnimation {
                                            let newItem = addItem(name: "", order: items.count)
                                            focusedItem.wrappedValue = .row(id: newItem.id.uuidString)
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                                withAnimation {
                                                    proxy.scrollTo(newItem, anchor: .bottom)
                                                }
                                            }
                                        }
                                    } label: {
                                        Image(systemName: "plus")
                                            .imageScale(.large)
                                            .padding(4)
                                    }
                                    .disabled(isEditing)
                                }
                            } //: HStack
                        } //: Section
                    } //: List
                    .listStyle(.plain)
                    .opacity(items.isEmpty ? 0 : 1)
                    .environment(\.editMode, editMode)
                } //: ScrollViewReader
                if items.isEmpty && !listNameTextFieldIsFocused.wrappedValue {
                    Rectangle()
                        .foregroundColor(.clear)
                        .contentShape(Rectangle())
                        .overlay {
                            Text("No Items")
                                .font(.title3)
                                .foregroundColor(Color(UIColor.tertiaryLabel))
                                .offset(y: -28)
                        }
                        .onTapGesture {
                            withAnimation {
                                let newItem = addItem(name: "", order: items.count)
                                focusedItem.wrappedValue = .row(id: newItem.id.uuidString)
                            }
                        }
                }
            }
        } //: VStack
    }
    
    private func saveData() {
        guard let itemList = itemList else { return }
        do {
            itemList.updateDate = Date()
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    @discardableResult
    private func addItem(name: String, order: Int) -> Item {
        for index in order ..< items.count {
            items[index].order += 1
        }
        let newItem = itemList!.createNewItem(name: name, order: order, viewContext)
        saveData()
        return newItem
    }
    
    private func deleteItems(offsets: IndexSet, animation: Animation? = .default) {
        withAnimation(animation) {
            offsets.forEach { deleteIndex in
                viewContext.delete(items[deleteIndex])
                if deleteIndex != items.count-1 {
                    for index in deleteIndex+1 ... items.count-1 {
                        items[index].order -= 1
                    }
                }
            }
            saveData()
        }
    }
    
    private func moveitem(indexSet: IndexSet, destination: Int) {
        withAnimation {
            indexSet.forEach { source in
                if source < destination {
                    var startIndex = source + 1
                    let endIndex = destination - 1
                    var startOrder = items[source].order
                    while startIndex <= endIndex {
                        items[startIndex].order = startOrder
                        startOrder += 1
                        startIndex += 1
                    }
                    items[source].order = startOrder
                } else if destination < source {
                    var startIndex = destination
                    let endIndex = source - 1
                    var startOrder = items[destination].order + 1
                    let newOrder = items[destination].order
                    while startIndex <= endIndex {
                        items[startIndex].order = startOrder
                        startOrder += 1
                        startIndex += 1
                    }
                    items[source].order = newOrder
                }
                saveData()
            }
        }
    }
}

struct EditItemListView_Previews: PreviewProvider {
    
    @FocusState static var listNameTextFieldIsFocused: Bool
    @FocusState static var focusedItem: Focusable?
    
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        let itemList = MonoListManager().fetchItemLists(context: context)[0]
        EditItemListView(of: itemList, listNameTextFieldIsFocused: $listNameTextFieldIsFocused, focusedItem: $focusedItem)
            .environment(\.managedObjectContext, context)
    }
}
