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
    @Environment(\.dismiss) var dismiss
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
                            if folder.name != K.defaultName.newFolder {
                                NavigationLink {
                                    EditFolderView(folder: folder)
                                } label: {
                                    Label(folder.name, systemImage: folder.image)
                                        .id(folder.name)
                                }
                            }
                        }
                        .onDelete(perform: deleteFolders)
                        .onMove(perform: moveFolder)
                        Button(action: {
                            newFolder = addFolder(order: folders.count, viewContext)
                            isEditingNewFolder = true
                            saveData()
                        }) {
                            ZStack {
                                Label("Add Folder", systemImage: "plus")
                            }
                        }
                    } header: {
                        HStack(alignment: .center) {
                            Text("Edit Folders")
                                .font(.headline)
                                .foregroundColor(.primary)
                            Spacer()
                            EditButtonView()
                                .environment(\.editMode, $editMode)
                        }
                    } //: Section
                } //: List
                .environment(\.editMode, $editMode)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "xmark")
                        }
                        .buttonStyle(CircleButton())
                    }
                }
                NavigationLink(isActive: $isEditingNewFolder) {
                    if let editingFolder = newFolder {
                        EditFolderView(folder: editingFolder)
                            .onDisappear {
                                if editingFolder.name == K.defaultName.newFolder {
                                    deleteFolders(offsets: IndexSet(integer: folders.count-1))
                                }
                            }
                    }
                } label: {
                    EmptyView()
                }
            } //: ZStack
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

struct SortFoldersView_Previews: PreviewProvider {
    static var previews: some View {
        SortFoldersView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
