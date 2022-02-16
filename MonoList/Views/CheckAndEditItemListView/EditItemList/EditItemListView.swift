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
    
    var isShowingNoItems: Bool {
        items.isEmpty && !listNameTextFieldIsFocused.wrappedValue
    }
    
    @State var scrollViewProxy: ScrollViewProxy?
    
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
                                if !item.isFault && !item.isDeleted {
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
                                                withAnimation {
                                                    proxy.scrollTo(newItem, anchor: .bottom)
                                                }
                                                focusedItem.wrappedValue = .row(id: newItem.id.uuidString)
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
                                        .tint(.red)
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
                            } //: ForEach
                            .onDelete(perform: { indexSet in
                                deleteItems(offsets: indexSet)
                            })
                            .onMove(perform: moveitem)
                            if !isEditing {
                                Button(action: {
                                    let focusedItemNameIsEmpty = items.first(where: {
                                        focusedItem.wrappedValue == .row(id: $0.id.uuidString)
                                    })?.name != ""
                                    guard focusedItemNameIsEmpty else { return }
                                    withAnimation {
                                        let newItem = addItem(name: "", order: items.count)
                                        scrollViewProxy?.scrollTo(newItem, anchor: .bottom)
                                        for index in 0 ..< 50 {
                                            if focusedItem.wrappedValue != .row(id: newItem.id.uuidString) {
                                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.01*Double(index)) {
                                                    focusedItem.wrappedValue = .row(id: newItem.id.uuidString)
                                                }
                                            } else {
                                                break
                                            }
                                        }
                                        for index in 0 ..< 70 {
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01*Double(index)) {
                                                scrollViewProxy?.scrollTo(newItem, anchor: .bottom)
                                            }
                                        }
                                    }
                                }) {
                                    Label {
                                        Text("New Item")
                                            .foregroundStyle(.tint)
                                    } icon: {
                                        Image(systemName: "plus.circle.fill")
                                            .foregroundStyle(.tint)
                                    }
                                    .font(.body.bold())
                                    .labelStyle(.titleAndIcon)
                                }
                                .buttonStyle(.plain)
                                .padding(.leading, 8)
                            }
                        } header: {
                            HStack {
                                Spacer()
                                HStack(spacing: 12) {
                                    Menu {
                                        Button {
                                            withAnimation {
                                                itemList?.sortItems(order: .category)
                                                saveData()
                                            }
                                        } label: {
                                            Label("Category", systemImage: "tag")
                                        }
                                        Button {
                                            withAnimation {
                                                itemList?.sortItems(order: .important)
                                                saveData()
                                            }
                                        } label: {
                                            Label("Priority", systemImage: "exclamationmark")
                                        }
                                        Menu {
                                            Button {
                                                withAnimation {
                                                    itemList?.sortItems(order: .light)
                                                    saveData()
                                                }
                                            } label: {
                                                Label("Ascending", systemImage: "arrow.up.right")
                                            }
                                            Button {
                                                withAnimation {
                                                    itemList?.sortItems(order: .heavy)
                                                    saveData()
                                                }
                                            } label: {
                                                Label("Descending", systemImage: "arrow.down.right")
                                            }
                                        } label: {
                                            Label("Weight", systemImage: "scalemass")
                                        }
                                        Menu {
                                            Button {
                                                withAnimation {
                                                    itemList?.sortItems(order: .few)
                                                    saveData()
                                                }
                                            } label: {
                                                Label("Ascending", systemImage: "arrow.up.right")
                                            }
                                            Button {
                                                withAnimation {
                                                    itemList?.sortItems(order: .many)
                                                    saveData()
                                                }
                                            } label: {
                                                Label("Descending", systemImage: "arrow.down.right")
                                            }
                                        } label: {
                                            Label("Quantity", systemImage: "number")
                                        }
                                    } label: {
                                        EditLabelView {}
                                            .environment(\.editMode, editMode)
                                    } primaryAction: {
                                        listNameTextFieldIsFocused.wrappedValue = false
                                        withAnimation {
                                            editMode?.wrappedValue = isEditing ? .inactive : .active
                                        }
                                    }
                                    .disabled(items.count == 1)
                                }
                            } //: HStack
                        } //: Section
                    } //: List
                    .listStyle(.plain)
                    .opacity(items.isEmpty ? 0 : 1)
                    .environment(\.editMode, editMode)
                    .onAppear {
                        scrollViewProxy = proxy
                    }
                } //: ScrollViewReader
                if isShowingNoItems {
                    NoItemsView()
                        .animation(.easeOut(duration: 0.2), value: isShowingNoItems)
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
            print("Saved (List)")
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
