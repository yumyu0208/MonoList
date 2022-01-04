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
    @State var isEditingFolder = false
    @State var isSortingFolders = false
    @State var editingFolder: Folder?

    var body: some View {
        NavigationView {
            List {
                ForEach(folders) { folder in
                    Section {
                        ItemListsView(of: folder)
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
                        let newFolder = addFolder(order: folders.count, viewContext)
                        editingFolder = newFolder
                        isEditingFolder = true
                        saveData()
                    }) {
                        Label("Add Folder", systemImage: "plus")
                    }
                    .disabled(isEditing)
                    .sheet(isPresented: $isEditingFolder, onDismiss: {
                        if editingFolder?.name == K.defaultName.newFolder {
                            deleteFolders(offsets: IndexSet(integer: folders.count-1))
                        }
                    }, content: {
                        EditFolderView(folder: editingFolder!)
                    })
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
    private func addFolder(name: String = K.defaultName.newFolder, image: String = "folder", order: Int, _ context: NSManagedObjectContext) -> Folder {
        let newFolder = manager.createNewFolder(name: name, image: image, order: order, context)
        return newFolder
    }

    private func deleteFolders(offsets: IndexSet) {
        withAnimation {
            offsets.forEach { deleteIndex in
                viewContext.delete(folders[deleteIndex])
                if deleteIndex != folders.count-1 {
                    for index in deleteIndex+1 ... folders.count-1 {
                        folders[index].order -= 1
                    }
                }
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
    
    @discardableResult
    func addItemList(name: String = "default_newList", color: String = K.listColors.basic.green, image: String = "checklist", order: Int) -> ItemList {
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
