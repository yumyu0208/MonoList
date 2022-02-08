//
//  SelectDestinationView.swift
//  MonoList
//
//  Created by 竹田悠真 on 2022/01/13.
//

import SwiftUI

struct SelectDestinationView: View {
    @EnvironmentObject var manager: MonoListManager
    @Environment(\.dismiss) private var dismiss
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: [SortDescriptor(\.order, order: .forward)], animation: .default)
    private var folders: FetchedResults<Folder>
    
    @ObservedObject var itemList: ItemList
    let moveAciton: (ItemList, Folder) -> Void
    @State var isEditingNewFolder = false
    @State var newFolder: Folder?
    
    var body: some View {
        ZStack {
            List {
                Section {
                    ForEach(folders) { folder in
                        if folder != itemList.parentFolder {
                            Button {
                                dismiss()
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                    moveAciton(itemList, folder)
                                }
                            } label: {
                                Label {
                                    Text(folder.name)
                                        .foregroundColor(.primary)
                                } icon: {
                                    Image(systemName: folder.image)
                                }
                            } //: Button
                        }
                    } //: ForEach
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
                    } //: Button
                } header: {
                    Label {
                        Text(itemList.name)
                            .foregroundColor(.primary)
                            .textCase(nil)
                    } icon: {
                        IconImageView(for: itemList)
                    }
                    .font(.headline.bold())
                    .padding(.bottom)
                } //: Section
            } //: List
            NavigationLink(isActive: $isEditingNewFolder) {
                if let editingFolder = newFolder {
                    EditFolderView(folder: editingFolder)
                        .navigationTitle(Text("New Folder"))
                        .onDisappear {
                            if !editingFolder.isFault && editingFolder.name != K.defaultName.newFolder {
                                dismiss()
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                    moveAciton(itemList, editingFolder)
                                }
                            }
                        }
                }
            } label: {
                EmptyView()
            }
        } //: ZStack
        .navigationTitle("Select a Folder")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                XButtonView {
                    dismiss()
                }
            }
        }
    }
    
    private func saveData() {
        do {
            try viewContext.save()
            print("Saved")
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
    
}

struct SelectDestinationView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        let itemList = MonoListManager().fetchItemLists(context: context)[0]
        NavigationView {
            SelectDestinationView(itemList: itemList) { _ , _ in }
                .environment(\.managedObjectContext, context)
        }
    }
}
