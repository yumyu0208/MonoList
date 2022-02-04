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
                .environment(\.editMode, $editMode)
                NavigationLink(tag: editItemListTag,
                               selection: $navigationLinkTag) {
                    editItemListView
                } label: {
                    EmptyView()
                } //: NavigationLink
            } //: ZStack
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                let isEditing = (editMode == .active)
                ToolbarItem(placement: .navigationBarLeading) {
                    Label {
                        Text("MONOLIST")
                            .fontWeight(.heavy)
                    } icon: {
                        Image(systemName: "checklist")
                    }
                    .font(.system(.title3, design: .default).bold())
                    .labelStyle(.titleAndIcon)
                } //: ToolBarItem
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Group {
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
                        EditButtonView(imageOnly: true)
                            .environment(\.editMode, $editMode)
                        Button(action: {
                            let newItemList = addItemList(order: folders.first!.itemLists?.count ?? 0)
                            saveData()
                            editItemListView = ItemListView(itemList: newItemList, isEditMode: true)
                            navigationLinkTag = editItemListTag
                        }) {
                            Label("Add Item List", systemImage: "plus")
                        }
                        .disabled(isEditing)
                    } //: Group
                    .imageScale(.large)
                    .padding(.horizontal, -4)
                } //: ToolBarItemGroup
            }
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
    
    func addItemList(order: Int) -> ItemList {
        if let folder = folders.first {
            var iconManager = ListIconManager()
            iconManager.loadData()
            let randomIcon = iconManager.randomCheckListIcon()
            let newItemList = folder.createNewItemList(name: K.defaultName.newItemList,
                                                       color: randomIcon.color,
                                                       primaryColor: randomIcon.primaryColor,
                                                       secondaryColor: randomIcon.secondaryColor,
                                                       iconName: randomIcon.name,
                                                       image: randomIcon.image,
                                                       order: order, viewContext)
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
