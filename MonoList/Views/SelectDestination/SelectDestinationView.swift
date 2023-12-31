//
//  SelectDestinationView.swift
//  MonoList
//
//  Created by 竹田悠真 on 2022/01/13.
//

import SwiftUI

struct SelectDestinationView: View {
    @AppStorage(K.key.isPlusPlan) private var isPlusPlan: Bool = false
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
                                    Text(folderName(for: folder))
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
                        HStack {
                            Label("Add Folder", systemImage: "folder.badge.plus")
                            Spacer()
                        }
                    } //: Button
                    .inoperable(!isPlusPlan, padding: .defaultListInsets) {
                        NavigationView {
                            PlusPlanView(feature: K.plusPlan.folders)
                        }
                    }
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
    
    private func folderName(for folder: Folder) -> String {
        if folder.name == K.defaultName.newFolder {
            return "New Folder".localized
        } else if folder.name == K.defaultName.lists {
            return "My Lists".localized
        } else {
            return folder.name
        }
    }
    
    private func saveData() {
        do {
            try viewContext.save()
            #if DEBUG
            print("Saved")
            #endif
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
