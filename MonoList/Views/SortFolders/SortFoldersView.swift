//
//  SortFoldersView.swift
//  MonoList
//
//  Created by 竹田悠真 on 2022/01/03.
//

import SwiftUI
import CoreData

struct SortFoldersView: View {
    
    @EnvironmentObject var manager: MonoListManager
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    @FetchRequest(sortDescriptors: [SortDescriptor(\.order, order: .forward)], animation: .default)
    private var folders: FetchedResults<Folder>
    
    @State var editMode: EditMode = .inactive
    @State var isEditingNewFolder = false
    @State var newFolder: Folder?
    
    var body: some View {
        NavigationView {
            ZStack {
                List {
                    Section {
                        ForEach(folders) { folder in
                            if folder.name != K.defaultName.lists {
                                NavigationLink {
                                    EditFolderView(folder: folder)
                                        .navigationTitle(Text("Edit Folder"))
                                } label: {
                                    Label(folder.name, systemImage: folder.image)
                                        .id(folder.name)
                                }
                            }
                        }
                        .onDelete(perform: deleteFolders)
                        .onMove(perform: moveFolder)
                        if editMode != .active {
                            Button(action: {
                                withAnimation {
                                    newFolder = addFolder(order: folders.count)
                                    isEditingNewFolder = true
                                    saveData()
                                }
                            }) {
                                ZStack {
                                    Label("Add Folder", systemImage: "folder.badge.plus")
                                }
                            }
                        }
                    } header: {
                        HStack(alignment: .center) {
                            Spacer()
                            EditButtonView()
                                .environment(\.editMode, $editMode)
                        }
                    } //: Section
                } //: List
                .listStyle(.insetGrouped)
                .environment(\.editMode, $editMode)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "xmark")
                        }
                        .buttonStyle(CircleButtonStyle(type: .cancel))
                    }
                }
                NavigationLink(isActive: $isEditingNewFolder) {
                    if let editingFolder = newFolder {
                        EditFolderView(folder: editingFolder)
                            .navigationTitle(Text("New Folder"))
                    }
                } label: {
                    EmptyView()
                }
            } //: ZStack
            .navigationTitle(Text("Edit Folders"))
            .navigationBarTitleDisplayMode(.inline)
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
    private func addFolder(name: String = K.defaultName.newFolder, image: String = "folder", order: Int) -> Folder {
        let newFolder = manager.createNewFolder(name: name, image: image, order: order, viewContext)
        return newFolder
    }
    
    private func deleteFolders(offsets: IndexSet) {
        withAnimation {
            offsets.forEach { deleteIndex in
                Folder.delete(index: deleteIndex, folders: folders, viewContext)
            }
            saveData()
        }
    }
    
    private func deleteFoldersWithoutDeletingItemLists(offsets: IndexSet) {
        guard let defaultFolder = folders.first else { return }
        withAnimation {
            offsets.forEach { deleteIndex in
                
                // Move ItemLists to Default Folder
                if let itemLists = folders[deleteIndex].itemLists?.allObjects as? [ItemList] {
                    itemLists.forEach { itemList in
                        moveItemList(itemList, to: defaultFolder)
                    }
                }
                Folder.delete(index: deleteIndex, folders: folders, viewContext)
            }
            saveData()
        }
    }
    
    private func moveFolder(indexSet: IndexSet, destination: Int) {
        withAnimation {
            indexSet.forEach { source in
                if source < destination {
                    var startIndex = source + 1
                    let endIndex = destination - 1
                    var startOrder = folders[source].order
                    while startIndex <= endIndex {
                        folders[startIndex].order = startOrder
                        startOrder += 1
                        startIndex += 1
                    }
                    folders[source].order = startOrder
                } else if destination < source {
                    var startIndex = destination
                    let endIndex = source - 1
                    var startOrder = folders[destination].order + 1
                    let newOrder = folders[destination].order
                    while startIndex <= endIndex {
                        folders[startIndex].order = startOrder
                        startOrder += 1
                        startIndex += 1
                    }
                    folders[source].order = newOrder
                }
                saveData()
            }
        }
    }
    
    private func moveItemList(_ itemList: ItemList, to folder: Folder) {
        withAnimation {
            guard let itemLists = itemList.parentFolder.itemLists?.allObjects as? [ItemList] else { return }
            let deleteIndex = itemLists.firstIndex(of: itemList) ?? 0
            if deleteIndex != itemLists.count-1 {
                for index in deleteIndex+1 ..< itemLists.count {
                    itemLists[index].order -= 1
                }
            }
            itemList.parentFolder.removeFromItemLists(itemList)
            itemList.order = Int32(folder.itemLists?.count ?? 0)
            folder.addToItemLists(itemList)
            saveData()
        }
    }
}

struct SortFoldersView_Previews: PreviewProvider {
    static var previews: some View {
        SortFoldersView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
