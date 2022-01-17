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
    @State private var editMode: EditMode = .inactive
    @State private var isSortingFolders = false
    
    private let editItemListTag: Int = 888
    @State var navigationLinkTag: Int?
    @State var editItemListView: ItemListView?
    
    private let willTerminateObserver = NotificationCenter.default.publisher(for: UIApplication.willTerminateNotification)

    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    HStack {
                        Spacer()
                        EditButtonView()
                            .imageScale(.medium)
                            .font(.subheadline.bold())
                            .environment(\.editMode, $editMode)
                    }
                    .padding(.horizontal)
                    .padding(.top)
                    List {
                        ForEach(folders) { folder in
                            Section {
                                ItemListsView(of: folder) { itemList in
                                    editItemListView = ItemListView(itemList: itemList, isEditMode: true)
                                    navigationLinkTag = editItemListTag
                                }
                                .environmentObject(manager)
                            } header: {
                                FolderSectionView(image: folder.image, title: folder.name)
                            } //: Section
                        } //: ForEach
                    } //: List
                    .listStyle(.sidebar)
                    .navigationTitle(Text("MONOLIST"))
                    .navigationBarTitleDisplayMode(.inline)
                    .environment(\.editMode, $editMode)
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
                                let newItemList = addItemList(order: folders.first!.itemLists?.count ?? 0)
                                saveData()
                                editItemListView = ItemListView(itemList: newItemList, isEditMode: true)
                                navigationLinkTag = editItemListTag
                            }) {
                                Label("Add Item List", systemImage: "plus")
                            }
                            .disabled(isEditing)
                            Button {
                                
                            } label: {
                                Label("Settings", systemImage: "gearshape")
                            }
                            .disabled(isEditing)
                        } //: ToolBarItemGroup
                    }
                } //: VStack
                .background(Color(UIColor.systemGroupedBackground))
                NavigationLink(tag: editItemListTag,
                               selection: $navigationLinkTag) {
                    editItemListView
                } label: {
                    EmptyView()
                } //: NavigationLink
            } //: ZStack
        } //: Navigation
        .onAppear {
            if folders.isEmpty {
                manager.createSamples(context: viewContext)
            }
        }
        .onReceive(willTerminateObserver) { _ in
            saveData()
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
