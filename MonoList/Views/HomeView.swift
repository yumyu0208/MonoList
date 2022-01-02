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
    @State var editMode: EditMode = .inactive
    @FetchRequest(sortDescriptors: [SortDescriptor(\.order, order: .forward)], animation: .default)
    private var folders: FetchedResults<Folder>
    
    let manager = MonoListManager()
    @State var isEditingFolder = false
    @State var editingFolder: Folder?

    var body: some View {
        NavigationView {
            List {
                ForEach(folders) { folder in
                    Section {
                        ForEach(0 ..< 3) { index in
                            Text("ItemLists - \(index)")
                        }
                        .onDelete(perform: deleteFolders)
                        .onMove(perform: moveFolder)
                    } header: {
                        HStack(alignment: .bottom) {
                            FolderSectionView(image: folder.image, title: folder.name)
                            if folder.order == 0 {
                                SortButtonView()
                                    .environment(\.editMode, $editMode)
                            }
                        }
                    } //: Section
                } //: ForEach
            } //: List
            .navigationTitle("MONOLIST")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        
                    } label: {
                        Label("Folders", systemImage: "folder")
                    }
                }
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button(action: {
                        let newFolder = addFolder(order: folders.count, viewContext)
                        editingFolder = newFolder
                        isEditingFolder = true
                        saveData()
                    }) {
                        Label("Add Folder", systemImage: "plus")
                    }
                    .sheet(isPresented: $isEditingFolder, onDismiss: {
                        if editingFolder?.name == K.defaultName.newFolder {
                            deleteFolders(offsets: IndexSet(integer: folders.count-1))
                        }
                    }, content: {
                        EditFolderView(folder: Binding($editingFolder)!)
                    })
                    Button {
                        
                    } label: {
                        Label("Settings", systemImage: "gearshape")
                    }

                }
            }
            .environment(\.editMode, $editMode)
        } //: Navigation
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
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
