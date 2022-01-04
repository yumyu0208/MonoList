//
//  ContentView.swift
//  MonoList
//
//  Created by 竹田悠真 on 2021/12/25.
//

import SwiftUI
import CoreData

struct HomeView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: [SortDescriptor(\.order, order: .forward)], animation: .default)
    private var folders: FetchedResults<Folder>
    
    @State var manager = MonoListManager()
    @State var editMode: EditMode = .inactive
    @State var isSortingFolders = false
    @State var editingItemList: ItemList?

    var body: some View {
        NavigationView {
            List {
                ForEach(folders) { folder in
                    Section {
                        ItemListsView(of: folder) { itemList in
                            editingItemList = itemList
                        }
                    } header: {
                        HStack(alignment: .center) {
                            FolderSectionView(image: folder.image, title: folder.name)
                            if folder.order == 0 {
                                EditButtonView()
                                    .environment(\.editMode, $editMode)
                            }
                        }
                    } //: Section
                } //: ForEach
            } //: List
            .navigationTitle("MONOLIST")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                let isEditing = (editMode == .active)
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        isSortingFolders = true
                    } label: {
                        Label("Folders", systemImage: "folder")
                    }
                    .disabled(isEditing)
                    .sheet(isPresented: $isSortingFolders) {
                        SortFoldersView()
                            .environmentObject(manager)
                    }
                } //: ToolBarItem
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button(action: {
                        editingItemList = addItemList(order: folders.first!.itemLists?.count ?? 0)
                        saveData()
                    }) {
                        Label("Add Item List", systemImage: "plus")
                    }
                    .disabled(isEditing)
                    .fullScreenCover(item: $editingItemList) { itemList in
                        NavigationView {
                            EditItemListView(of: itemList)
                        }
                    }
                    Button {
                        
                    } label: {
                        Label("Settings", systemImage: "gearshape")
                    }
                    .disabled(isEditing)
                } //: ToolBarItemGroup
            }
            .environment(\.editMode, $editMode)
        } //: Navigation
        .onAppear {
            if folders.isEmpty {
                manager.createSamples(context: viewContext)
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
    
    @discardableResult
    func addItemList(name: String = K.defaultName.newItemList, color: String = K.listColors.basic.green, image: String = "checklist", order: Int) -> ItemList {
        if let folder = folders.first {
            let newItemList = folder.createNewItemList(name: name, color: color, image: image, order: order, viewContext)
            saveData()
            return newItemList
        } else {
            fatalError("Falied to add Item List - No Folders")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
