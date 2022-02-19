//
//  ItemListView.swift
//  MonoList
//
//  Created by 竹田悠真 on 2022/01/15.
//

import SwiftUI
import ImageViewer

struct ItemListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    @State var editMode: EditMode = .inactive
    @ObservedObject var itemList: ItemList
    @State var isEditMode: Bool
    
    @State var itemListName: String = ""
    @State var itemListIconName: String = "Checklist Red"
    @State var itemListImage: String = "checklist"
    @State var itemListColor: String = K.colors.basic.red
    @State var itemListPrimaryColor: String? = K.colors.basic.red
    @State var itemListSecondaryColor: String? = K.colors.basic.gray
    @State var itemListTertiaryColor: String? = nil
    @FocusState var listNameTextFieldIsFocused: Bool
    @FocusState var focusedItem: Focusable?
    @State var isShowingEditNotification = false
    @State var isShowingWeight = false
    @State var isShowingEditIcon = false
    @State var doneAlertIsShowing = false
    @State var isShowingUncheckAllConfirmationAlert: Bool = false
    
    @State var isShowingImageViewer = false
    @State var showingImage: Image?
    
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
            HStack(spacing: isEditMode ? 14 : 8) {
                Group {
                    Button {
                        if isEditMode {
                            isShowingEditIcon = true
                        }
                    } label: {
                        ZStack {
                            Image(systemName: "square")
                                .foregroundColor(.clear)
                                .padding(8)
                            IconImageView(for: itemList)
                        }
                    }
                    .background(
                        Color(K.colors.ui.secondaryBackgroundColor)
                            .opacity(isEditMode ? 1 : 0)
                    )
                    .buttonStyle(.darkHighlight)
                    .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                    .shadow(color: isEditMode ? Color(.sRGBLinear, white: 0, opacity: 0.33) : .clear,
                            radius: 2)
                    .disabled(!isEditMode)
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
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                    listNameTextFieldIsFocused = false
                                }
                            }
                            saveDataIfNeeded()
                        }
                }
                .font(.title.bold())
                Button {
                    itemListName = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .imageScale(.large)
                }
                .buttonStyle(.plain)
                .foregroundColor(Color(UIColor.systemGray4))
                .opacity(isEditMode && !itemListName.isEmpty ? 1 : 0)
                .animation(.easeOut(duration: 0.2), value: itemListName.isEmpty)
            } //: HStack
            .padding(.horizontal)
            .padding(.vertical, 8)
            .tint(Color(itemList.color))
            .disabled(isEditing)
            ZStack {
                NoItemsView()
                    .opacity(!isEditMode && itemsIsEmpty ? 1 : 0)
                    .onTapGesture {
                        withAnimation(.easeOut(duration: 0.2)) {
                            isEditMode = true
                        }
                    }
                EditItemListView(of: itemList, listNameTextFieldIsFocused: $listNameTextFieldIsFocused, focusedItem: $focusedItem)
                    .opacity(isEditMode ? 1 : 0)
                    .environment(\.editMode, $editMode)
                CheckListView(of: itemList, allDoneAction: {
                    if !isEditMode && !itemsIsEmpty {
                        withAnimation(.easeOut(duration: 0.2).delay(0.3)) {
                            doneAlertIsShowing = true
                        }
                    }
                }, showImageViewerAction: { image in
                    showingImage = image
                    isShowingImageViewer = true
                })
                .opacity(isEditMode || itemsIsEmpty ? 0 : 1)
            } //: ZStack
            .tint(Color(itemList.color))
        } //: VStack
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .overlay(ImageViewer(image: $showingImage, viewerShown: $isShowingImageViewer, closeButtonTopRight: true))
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    setValue(to: itemList)
                    dismiss()
                } label: {
                    Image(systemName: "chevron.backward")
                        .font(.body.bold())
                        .imageScale(.large)
                        .contentShape(Rectangle())
                        .padding(.trailing)
                }
                .disabled(isEditing || isShowingImageViewer)
            } //: ToolBarItem
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Group {
                    Button {
                        isShowingEditNotification = true
                    } label: {
                        Label("Alarm", systemImage: itemList.notificationIsActive ? "bell" : "bell.slash")
                            .padding(4)
                    } //: Button
                    Button {
                        isShowingWeight = true
                    } label: {
                        Label("Weight", systemImage: "scalemass")
                            .padding(4)
                    } //: Button
                    EditItemListButtonView(isEditMode: $isEditMode) {
                        focusedItem = nil
                        listNameTextFieldIsFocused = false
                        if isEditMode {
                            saveDataIfNeeded()
                        } else {
                            saveData(update: false)
                        }
                    }
                    Menu {
                        if isEditMode {
                            Menu {
                                Button {
                                    withAnimation {
                                        itemList.sortItems(order: .category)
                                        saveData(update: true)
                                    }
                                } label: {
                                    Label("Category", systemImage: "tag")
                                }
                                Button {
                                    withAnimation {
                                        itemList.sortItems(order: .important)
                                        saveData(update: true)
                                    }
                                } label: {
                                    Label("Priority", systemImage: "exclamationmark")
                                }
                                Menu {
                                    Button {
                                        withAnimation {
                                            itemList.sortItems(order: .light)
                                            saveData(update: true)
                                        }
                                    } label: {
                                        Label("Ascending", systemImage: "arrow.up.right")
                                    }
                                    Button {
                                        withAnimation {
                                            itemList.sortItems(order: .heavy)
                                            saveData(update: true)
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
                                            itemList.sortItems(order: .few)
                                            saveData(update: true)
                                        }
                                    } label: {
                                        Label("Ascending", systemImage: "arrow.up.right")
                                    }
                                    Button {
                                        withAnimation {
                                            itemList.sortItems(order: .many)
                                            saveData(update: true)
                                        }
                                    } label: {
                                        Label("Descending", systemImage: "arrow.down.right")
                                    }
                                } label: {
                                    Label("Quantity", systemImage: "number")
                                }
                            } label: {
                                Label("Sort", systemImage: "arrow.up.arrow.down")
                            }
                            .disabled(itemsIsEmpty)
                        } else {
                            Menu {
                                ForEach(ItemList.allForms, id: \.rawValue) { form in
                                    Button {
                                        withAnimation(.easeOut(duration: 0.2)) {
                                            itemList.form = form
                                            saveData(update: false)
                                        }
                                    } label: {
                                        Label("View as \(form.rawValue)", systemImage: imageName(for: form))
                                    } //: Button
                                } //: ForEach
                            } label: {
                                Label("Form", systemImage: imageName(for: itemList.form))
                            }
                            Button {
                                withAnimation(.easeOut(duration: 0.2)) {
                                    itemList.hideCompleted.toggle()
                                    saveData(update: false)
                                }
                            } label: {
                                Label(itemList.hideCompleted ? "Show Completed" : "Hide Completed", systemImage: itemList.hideCompleted ? "eye" : "eye.slash")
                            }
                            Button {
                                isShowingUncheckAllConfirmationAlert = true
                            } label: {
                                Label("Uncheck All", systemImage: "rays")
                            }
                        }
                    } label: {
                        Label("Menu", systemImage: "ellipsis")
                            .padding(4)
                    } //: Menu
                } //: Group
                .disabled(isEditing || isNewItemList || isShowingImageViewer)
            } //: ToolBarItemGroup
        }
        .richAlert(isShowing: $doneAlertIsShowing, vOffset: -24) {
            VStack(spacing: 32) {
                VStack {
                    IconImageView(for: itemList)
                        .font(.largeTitle)
                        .padding()
                    Text("All Done")
                        .font(.title.bold())
                }
                Button {
                    withAnimation(.easeOut(duration: 0.2)) {
                        doneAlertIsShowing = false
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                        dismiss()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            uncheckAllItems()
                        }
                        
                    }
                } label: {
                    Text("Close List")
                }
                .buttonStyle(.fitCapsule)
            }
            .padding()
        }
        .alert("Are you sure you want to uncheck all?", isPresented: $isShowingUncheckAllConfirmationAlert) {
            Button(role: .destructive) {
                uncheckAllItems()
            } label: {
                Text("Uncheck All")
            }
            Button("Cancel", role: .cancel) {
                isShowingUncheckAllConfirmationAlert = false
            }
        }
        .sheet(isPresented: $isShowingEditNotification) {
            if let itemList = itemList {
                NavigationView {
                    AlarmView(itemList: itemList)
                        .tint(Color(itemList.color))
                }
            }
        }
        .sheet(isPresented: $isShowingWeight) {
            if let itemList = itemList {
                NavigationView {
                    WeightView(itemList: itemList)
                        .tint(Color(itemList.color))
                }
            }
        }
        .sheet(isPresented: $isShowingEditIcon) {
            EditIconView(itemList: itemList,
                         selectedIcon: $itemListIconName,
                         image: $itemListImage,
                         color: $itemListColor,
                         primaryColor: $itemListPrimaryColor,
                         secondaryColor: $itemListSecondaryColor,
                         tertiaryColor: $itemListTertiaryColor) {
                setValue(to: itemList)
                saveData(update: true)
            }
        }
        .onAppear {
            itemListName = isNewItemList ? "" : itemList.name
            itemListIconName = itemList.iconName
            itemListImage = itemList.image
            itemListColor = itemList.color
            itemListPrimaryColor = itemList.primaryColor
            itemListSecondaryColor = itemList.secondaryColor
            itemListTertiaryColor = itemList.tertiaryColor
            if isNewItemList {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    listNameTextFieldIsFocused = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        if listNameTextFieldIsFocused == false {
                            listNameTextFieldIsFocused = true
                        }
                    }
                }
            }
        }
        .onDisappear {
            let newAndUnEdited = (itemList.name == K.defaultName.newItemList) && itemsIsEmpty
            if newAndUnEdited {
                deleteItemList()
            } else {
                if isEditMode {
                    withAnimation(.easeOut(duration: 0.2)) {
                        setValue(to: itemList)
                        saveDataIfNeeded()
                    }
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
    
    private func deleteItemList() {
        withAnimation {
            if let itemListsInSameFolders = itemList.parentFolder.itemLists?.allObjects as? [ItemList] {
                itemListsInSameFolders.forEach { itemList in
                    itemList.order -= 1
                }
            }
            viewContext.delete(itemList)
            saveData(update: false)
        }
    }
    
    private func uncheckAllItems() {
        withAnimation {
            guard let items = itemList.items?.allObjects as? [Item] else { return }
            items.forEach { $0.isCompleted = false }
            saveData(update: false)
        }
    }
    
    private func saveDataIfNeeded() {
        setValue(to: itemList)
        if viewContext.hasChanges {
            //print("The item list has been updated")
            saveData(update: true)
        }
    }
    
    private func setValue(to itemList: ItemList) {
        if itemList.name == K.defaultName.newItemList && itemListName.isEmpty && !itemsIsEmpty {
            itemList.name = "New List".localized
        } else if !itemListName.isEmpty && itemList.name != itemListName {
            itemList.name = itemListName
        }
        if itemList.iconName != itemListIconName {
            itemList.iconName = itemListIconName
        }
        if itemList.image != itemListImage {
            itemList.image = itemListImage
        }
        if itemList.color != itemListColor {
            itemList.color = itemListColor
        }
        if itemList.primaryColor != itemListPrimaryColor {
            itemList.primaryColor = itemListPrimaryColor
        }
        if itemList.secondaryColor != itemListSecondaryColor {
            itemList.secondaryColor = itemListSecondaryColor
        }
        if itemList.tertiaryColor != itemListTertiaryColor {
            itemList.tertiaryColor = itemListTertiaryColor
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
    
    private func imageName(for form: ItemList.Form) -> String {
        switch form {
        case .list:
            return "list.bullet"
        case .gallery:
            return "rectangle.grid.1x2"
        case .gallery2:
            return "square.grid.2x2"
        case .gallery3:
            return "square.grid.3x2"
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
