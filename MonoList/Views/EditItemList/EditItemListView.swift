//
//  ItemListView.swift
//  MonoList
//
//  Created by 竹田悠真 on 2022/01/04.
//

import SwiftUI

struct EditItemListView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    @Environment(\.scenePhase) private var scenePhase
    
    @FetchRequest var items: FetchedResults<Item>
    
    var itemList: ItemList?
    @State var editMode: EditMode = .inactive
    @State var itemListName: String = ""
    @State var itemListImage: String = "checklist"
    @State var itemListColor: String = K.listColors.basic.green
    
    @State var isSettingNotification = false
    @FocusState var focusedItem: Focusable?
    @FocusState var listNameTextFieldIsFocused: Bool
    
    var isNewItemList: Bool {
        itemList!.name == K.defaultName.newItemList
    }
    
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
        VStack(spacing: 0) {
            HStack {
                Group {
                    Image(systemName: itemListImage)
                        .foregroundColor(Color(itemListColor))
                    let itemsIsEmpty = items.isEmpty
                    TextField("List Name", text: $itemListName, prompt: Text("List Name"))
                        .focused($listNameTextFieldIsFocused)
                        .submitLabel(itemsIsEmpty ? .return : .done)
                        .onSubmit {
                            listNameTextFieldIsFocused = true
                            if itemsIsEmpty {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                    withAnimation {
                                        let newItem = addItem(name: "", order: 0)
                                        focusedItem = .row(id: newItem.id.uuidString)
                                    }
                                }
                            } else {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                                    listNameTextFieldIsFocused = false
                                }
                            }
                            saveDataIfNeeded()
                        }
                }
                .font(.title2.bold())
                HStack(spacing: 20) {
                    Button {
                        isSettingNotification = true
                    } label: {
                        Image(systemName: "bell")
                            .padding()
                    }
                    .sheet(isPresented: $isSettingNotification) {
                        Text("Setting Notification")
                    }
                    .buttonStyle(CircleButton(type: .primary))
                    .disabled(editMode == .active)
                    Button {
                        if itemListName.isEmpty && !items.isEmpty {
                            print("アラート：List Nameを入力してください")
                        } else {
                            if let itemList = itemList {
                                setValue(to: itemList)
                            }
                            dismiss()
                        }
                    } label: {
                        Image(systemName: "xmark")
                            .padding()
                    }
                    .buttonStyle(CircleButton(type: .cancel))
                    .disabled(editMode == .active)
                } //: HStack
            } //: HStack
            .padding()
            List {
                Section {
                    ForEach(items) { item in
                        EditItemCellView(item: item,
                        focusedItem: $focusedItem,
                        deleteAction: { item in
                            if let index = items.firstIndex(of: item) {
                                let isLastItem = (index == items.count-1)
                                deleteItems(offsets: IndexSet(integer: index), animation: isLastItem ? .none : .default)
                            }
                        }, addAction: { item in
                            focusedItem = .row(id: item.id.uuidString)
                            if let index = items.firstIndex(of: item) {
                                withAnimation {
                                    let newItem = addItem(name: "", order: index+1)
                                    focusedItem = .row(id: newItem.id.uuidString)
                                }
                            }
                        })
                            .disabled(editMode == .active)
                    }
                    .onDelete(perform: { indexSet in
                        deleteItems(offsets: indexSet)
                    })
                    .onMove(perform: moveitem)
                } header: {
                    HStack {
                        Spacer()
                        HStack(spacing: 12) {
                            EditButtonView()
                                .environment(\.editMode, $editMode)
                            Button {
                                withAnimation {
                                    let newItem = addItem(name: "", order: items.count)
                                    focusedItem = .row(id: newItem.id.uuidString)
                                }
                            } label: {
                                Image(systemName: "plus")
                                    .padding(4)
                            }
                            .disabled(editMode == .active)
                        }
                    }
                }
            } //: List
            .listStyle(.plain)
            .environment(\.editMode, $editMode)
        } //: VStack
        .onAppear {
            itemListName = isNewItemList ? "" : itemList!.name
            itemListImage = itemList!.image
            itemListColor = itemList!.color
        }
        .onDisappear {
            if let itemList = itemList {
                let newAndUnEdited = (itemList.name == K.defaultName.newItemList) && items.isEmpty
                if newAndUnEdited {
                    withAnimation {
                        viewContext.delete(itemList)
                        saveData()
                    }
                } else {
                    saveDataIfNeeded()
                }
            }
        }
        .onChange(of: scenePhase) { phase in
            if phase == .background {
                saveDataIfNeeded()
            }
        }
        .onChange(of: focusedItem) { [focusedItem] _ in
            if let index = items.firstIndex(where: {
                focusedItem == .row(id: $0.id.uuidString)
            }), items[index].name.isEmpty {
                let isLastItem = (index == items.count-1)
                deleteItems(offsets: IndexSet(integer: index), animation: isLastItem ? .none : .default)
            }
        }
    }
    
    private func saveDataIfNeeded() {
        if let itemList = itemList {
            setValue(to: itemList)
            if viewContext.hasChanges {
                //print("The item list has been updated")
                itemList.updateDate = Date()
                saveData()
            }
        }
    }
    
    private func setValue(to itemList: ItemList) {
        if !itemListName.isEmpty && itemList.name != itemListName {
            itemList.name = itemListName
        }
        if itemList.image != itemListImage {
            itemList.image = itemListImage
        }
        if itemList.color != itemListColor {
            itemList.color = itemListColor
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
    
    @discardableResult
    private func addItem(name: String, order: Int) -> Item {
        for index in order ..< items.count {
            items[index].order += 1
        }
        let newItem = itemList!.createNewItem(name: name, order: order, viewContext)
        saveDataIfNeeded()
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
            saveDataIfNeeded()
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
                saveDataIfNeeded()
            }
        }
    }
    
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
