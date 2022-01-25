//
//  ItemListView.swift
//  MonoList
//
//  Created by 竹田悠真 on 2022/01/15.
//

import SwiftUI

struct ItemListView: View {
    @AppStorage(K.key.showCompleted) var showCompleted = true
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    @State var editMode: EditMode = .inactive
    @ObservedObject var itemList: ItemList
    @State var isEditMode: Bool
    
    @State var itemListName: String = ""
    @State var itemListImage: String = "checklist"
    @State var itemListColor: String = K.colors.basic.green
    @FocusState var listNameTextFieldIsFocused: Bool
    @FocusState var focusedItem: Focusable?
    @State var isShowingTab: ItemListDetailView.Tab?
    @State var isShowingEditNotification = false
    
    var isNewItemList: Bool {
        itemList.name == K.defaultName.newItemList
    }
    var itemsIsEmpty: Bool {
        itemList.items?.count ?? 0 == 0
    }
    
    var isEditing: Bool {
        editMode == .active
    }
    
    var edgePanGesture: some Gesture {
        DragGesture()
            .onChanged { gesture in
                let xLength = gesture.startLocation.x - gesture.location.x
                let yLength = gesture.startLocation.y - gesture.location.y
                let slope = abs(yLength/xLength)
                if gesture.startLocation.x <= 20, slope < 1, xLength <= -40 {
                    print("アラート：List Nameを入力してください")
                }
            }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Group {
                    Image(systemName: itemListImage)
                        .foregroundColor(Color(itemListColor))
                    TextField("List Name", text: $itemListName, prompt: Text("List Name"))
                        .focused($listNameTextFieldIsFocused)
                        .submitLabel(.done)
                        .disabled(!isEditMode)
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
            } //: HStack
            .padding()
            .tint(Color(itemList.color))
            ZStack {
                NoItemsView()
                    .opacity(!isEditMode && itemsIsEmpty ? 1 : 0)
                    .onTapGesture {
                        isEditMode = true
                    }
                EditItemListView(of: itemList, listNameTextFieldIsFocused: $listNameTextFieldIsFocused, focusedItem: $focusedItem)
                    .opacity(isEditMode ? 1 : 0)
                    .environment(\.editMode, $editMode)
                CheckListView(of: itemList, showCompleted: showCompleted)
                    .opacity(isEditMode || itemsIsEmpty ? 0 : 1)
            } //: ZStack
            .tint(Color(itemList.color))
        } //: VStack
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .gesture((itemListName.isEmpty && !itemsIsEmpty) ? edgePanGesture : nil)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    if itemListName.isEmpty && !itemsIsEmpty {
                        print("アラート：List Nameを入力してください")
                    } else {
                        setValue(to: itemList)
                        dismiss()
                    }
                } label: {
                    Image(systemName: "chevron.backward")
                        .font(.body.bold())
                        .imageScale(.large)
                        .contentShape(Rectangle())
                        .padding(.trailing)
                }
                .disabled(isEditing)
            } //: ToolBarItem
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Group {
                    Button {
                        isShowingEditNotification = true
                    } label: {
                        Label("Alarm", systemImage: itemList.notificationIsActive ? "bell" : "bell.slash")
                    } //: Button
                    Button {
                        focusedItem = nil
                        listNameTextFieldIsFocused = false
                        if isEditMode {
                            saveDataIfNeeded()
                        } else {
                            saveData(update: false)
                        }
                        withAnimation(.easeOut(duration: 0.2)) {
                            isEditMode.toggle()
                        }
                    } label: {
                        Label("Edit", systemImage: "pencil")
                            .foregroundColor(isEditMode ? Color(K.colors.ui.buttonLabelColor) : Color.accentColor)
                            .padding(8)
                            .background(isEditMode ? Color.accentColor : .clear)
                            .clipShape(Circle())
                    } //: Button
                    Menu {
                        if !isEditMode {
                            Button {
                                showCompleted.toggle()
                            } label: {
                                Label(showCompleted ? "Hide Completed" : "Show Completed", systemImage: showCompleted ? "eye.slash" : "eye")
                            }
                            Button {
                                uncheckAllItems()
                            } label: {
                                Label("Uncheck All", systemImage: "rays")
                            }
                        }
                        Button {
                            isShowingTab = .info
                        } label: {
                            Label("Info", systemImage: "info.circle")
                        }
                    } label: {
                        Label("Menu", systemImage: "ellipsis")
                    } //: Menu
                } //: Group
                .disabled(isEditing || isNewItemList)
            } //: ToolBarItemGroup
        }
        .sheet(item: $isShowingTab) { tab in
            if let itemList = itemList {
                NavigationView {
                    ItemListDetailView(itemList: itemList, selectedTab: tab.rawValue)
                }
            }
        }
        .sheet(isPresented: $isShowingEditNotification) {
            if let itemList = itemList {
                NavigationView {
                    AlarmView(itemList: itemList)
                }
            }
        }
        .onAppear {
            itemListName = isNewItemList ? "" : itemList.name
            itemListImage = itemList.image
            itemListColor = itemList.color
            if isNewItemList {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    listNameTextFieldIsFocused = true
                }
            }
        }
        .onDisappear {
            let newAndUnEdited = (itemList.name == K.defaultName.newItemList) && itemsIsEmpty
            if newAndUnEdited {
                withAnimation {
                    viewContext.delete(itemList)
                    saveData(update: false)
                }
            } else {
                if isEditMode {
                    saveDataIfNeeded()
                } else {
                    saveData(update: false)
                }
            }
        }
        .onChange(of: focusedItem) { [focusedItem] newItem in
            guard var items = itemList.items?.allObjects as? [Item] else { return }
            items.sort(by: { $0.order < $1.order })
            if let oldIndex = items.firstIndex(where: {
                focusedItem == .row(id: $0.id.uuidString)
            }), items[oldIndex].name.isEmpty {
                let isLastItem = (oldIndex == items.count-1)
                deleteItems(allItems: items, offsets: IndexSet(integer: oldIndex), animation: isLastItem ? .none : .default)
            }
        }
    }
    
    @discardableResult
    private func addItem(name: String, order: Int) -> Item {
        let items = (itemList.items?.allObjects as? [Item]) ?? []
        for index in order ..< (items.count) {
            items[index].order += 1
        }
        let newItem = itemList.createNewItem(name: name, order: order, viewContext)
        saveData(update: true)
        return newItem
    }
    
    private func deleteItems(allItems: [Item], offsets: IndexSet, animation: Animation? = .default) {
        withAnimation(animation) {
            offsets.forEach { deleteIndex in
                viewContext.delete(allItems[deleteIndex])
                if deleteIndex != allItems.count-1 {
                    for index in deleteIndex+1 ... allItems.count-1 {
                        allItems[index].order -= 1
                    }
                }
            }
            saveData(update: true)
        }
    }
    
    private func uncheckAllItems() {
        guard let items = itemList.items?.allObjects as? [Item] else { return }
        items.forEach { $0.isCompleted = false }
        saveData(update: false)
    }
    
    private func saveDataIfNeeded() {
        setValue(to: itemList)
        if viewContext.hasChanges {
            //print("The item list has been updated")
            saveData(update: true)
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
    
    private func saveData(update: Bool) {
        do {
            if update {
                itemList.updateDate = Date()
            }
            try viewContext.save()
            print("Saved (List)")
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}

//struct ItemListView_Previews: PreviewProvider {
//    static var previews: some View {
//        let context = PersistenceController.preview.container.viewContext
//        let itemList = MonoListManager().fetchItemLists(context: context)[0]
//        ItemListView(itemList: itemList, isEditMode: false)
//            .environment(\.managedObjectContext, context)
//    }
//}
