//
//  ItemListView.swift
//  MonoList
//
//  Created by 竹田悠真 on 2022/01/15.
//

import SwiftUI

struct ItemListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    @Environment(\.scenePhase) private var scenePhase
    @State var editMode: EditMode = .inactive
    @ObservedObject var itemList: ItemList
    @State var isEditMode: Bool
    
    @State var itemListName: String = ""
    @State var itemListImage: String = "checklist"
    @State var itemListColor: String = K.listColors.basic.green
    @FocusState var listNameTextFieldIsFocused: Bool
    @FocusState var focusedItem: Focusable?
    @State var isSettingNotification = false
    
    var isNewItemList: Bool {
        itemList.name == K.defaultName.newItemList
    }
    var itemsIsEmpty: Bool {
        itemList.items?.count ?? 0 == 0
    }
    
    var isEditing: Bool {
        editMode == .active
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
                HStack(spacing: 20) {
                    Button {
                        isSettingNotification = true
                    } label: {
                        Image(systemName: "ellipsis")
                            .padding()
                    }
                    .sheet(isPresented: $isSettingNotification) {
                        if let itemList = itemList {
                            NavigationView {
                                EditItemListDetailView(itemList: itemList)
                            }
                        }
                    }
                    .buttonStyle(CircleButtonStyle(type: .primary))
                    .disabled(isEditing || isNewItemList)
                    Button {
                        focusedItem = nil
                        listNameTextFieldIsFocused = false
                        withAnimation(.easeOut(duration: 0.2)) {
                            isEditMode.toggle()
                        }
                    } label: {
                        Image(systemName: isEditMode ? "checklist" : "pencil")
                            .padding()
                            .id(isEditMode)
                    }
                    .buttonStyle(CircleButtonStyle(type: .primary))
                    .disabled(isEditing || isNewItemList)
                    Button {
                        if itemListName.isEmpty && !itemsIsEmpty {
                            print("アラート：List Nameを入力してください")
                        } else {
                            setValue(to: itemList)
                            dismiss()
                        }
                    } label: {
                        Image(systemName: "xmark")
                            .padding()
                    }
                    .buttonStyle(CircleButtonStyle(type: .cancel))
                    .disabled(isEditing)
                } //: HStack
            } //: HStack
            .padding()
            ZStack {
                EditItemListView(of: itemList, listNameTextFieldIsFocused: $listNameTextFieldIsFocused, focusedItem: $focusedItem)
                    .opacity(isEditMode ? 1 : 0)
                    .environment(\.editMode, $editMode)
                CheckListView(of: itemList)
                    .opacity(isEditMode ? 0 : 1)
            } //: ZStack
        } //: VStack
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
                    saveData()
                }
            } else {
                saveDataIfNeeded()
            }
        }
        .onChange(of: scenePhase) { phase in
            if phase == .background {
                saveDataIfNeeded()
            }
        }
        .onChange(of: focusedItem) { [focusedItem] newItem in
            guard let items = itemList.items?.allObjects as? [Item] else { return }
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
        saveData()
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
            saveData()
        }
    }
    
    private func saveDataIfNeeded() {
        setValue(to: itemList)
        if viewContext.hasChanges {
            //print("The item list has been updated")
            saveData()
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
            itemList.updateDate = Date()
            try viewContext.save()
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
