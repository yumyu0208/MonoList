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
    
    let manager = MonoListManager()
    @State var isEditingFolder = false
    @State var editingFolder: Folder?

    var body: some View {
        NavigationView {
            List {
                ForEach(folders) { folder in
                    NavigationLink {
                        Text(folder.name)
                    } label: {
                        Text("\(folder.name) - \(folder.order)")
                    }
                }
                .onDelete(perform: deleteFolders)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
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
                }
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
    private func addFolder(name: String = "default_newFolder", image: String = "folder", order: Int, _ context: NSManagedObjectContext) -> Folder {
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
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
