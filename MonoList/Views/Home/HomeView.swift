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
    
    @State private var isShowingSettings = false
    
    private let editItemListTag: Int = 888
    @State var navigationLinkTag: Int?
    @State var editItemListView: ItemListView?
    
    @State private var listOffset: CGFloat = 0
    
    private let willTerminateObserver = NotificationCenter.default.publisher(for: UIApplication.willTerminateNotification)
    
    var isEditing: Bool {
        editMode == .active
    }

    var body: some View {
        NavigationView {
            ZStack {
                VStack(spacing: 0) {
                    HStack {
                        Label {
                            Text("MONOLIST")
                                .fontWeight(.heavy)
                        } icon: {
                            Image(systemName: "cube")
                        }
                        .font(.system(.title2, design: .default).bold())
                        .labelStyle(.titleAndIcon)
                        Spacer()
                        Group {
                            EditLabelView(imageOnly: true)
                                .environment(\.editMode, $editMode)
                            Button {
                                isShowingSettings = true
                            } label: {
                                Label("Settings", systemImage: "gearshape")
                                    .padding(8)
                            }
                            .disabled(isEditing)
                            .sheet(isPresented: $isShowingSettings) {
                                SettingsView()
                                    .environmentObject(manager)
                            }
                        } //: Group
                        .imageScale(.large)
                        .labelStyle(.iconOnly)
                    } //: HStack
                    .padding(.vertical, 8)
                    .padding(.horizontal, 20)
                    .background(Color(UIColor.systemGroupedBackground))

                    List {
                        ForEach(folders) { folder in
                            Section {
                                ItemListsView(of: folder) { itemList in
                                    editItemListView = ItemListView(itemList: itemList, isEditMode: true)
                                    navigationLinkTag = editItemListTag
                                }
                                .environmentObject(manager)
                            } header: {
                                FolderSectionView(image: folder.image, title: folder.name, showPlusButton: !folder.isDefault) {
                                    withAnimation {
                                        let newItemList = addItemList(to: folder)
                                        editItemListView = ItemListView(itemList: newItemList, isEditMode: true)
                                        navigationLinkTag = editItemListTag
                                    }
                                }
                                .disabled(isEditing)
                            } //: Section
                        } //: ForEach
                    } //: List
                    .listStyle(.sidebar)
                    .environment(\.editMode, $editMode)
                    .onChange(of: listOffset) { newValue in
                        print(newValue)
                    }
                    HStack {
                        Group {
                            Button {
                                isSortingFolders = true
                            } label: {
                                Label("Folders", systemImage: "folder")
                                    .animation(.none, value: isEditing)
                            }
                            .disabled(isEditing)
                            .sheet(isPresented: $isSortingFolders) {
                                SortFoldersView()
                                    .environmentObject(manager)
                            }
                        } //: Group
                        .imageScale(.large)
                        .labelStyle(.iconOnly)
                        .padding(8)
                        Spacer()
                        Group {
                            Button(action: {
                                if let defaultFolder = folders.first {
                                    withAnimation {
                                        let newItemList = addItemList(to: defaultFolder)
                                        editItemListView = ItemListView(itemList: newItemList, isEditMode: true)
                                        navigationLinkTag = editItemListTag
                                    }
                                }
                            }) {
                                Label {
                                    Text("New List")
                                } icon: {
                                    Image(systemName: "plus.circle.fill")
                                }
                                .font(.body.bold())
                                .labelStyle(.titleAndIcon)
                                .animation(.none, value: isEditing)
                            }
                            .disabled(isEditing)
                        } //: Group
                        .imageScale(.large)
                        .labelStyle(.iconOnly)
                        .padding(8)
                    } //: HStack
                    .padding(.vertical, 8)
                    .padding(.horizontal, 20)
                    .background(Color(UIColor.systemGroupedBackground))
                } //: VStack
                NavigationLink(tag: editItemListTag,
                               selection: $navigationLinkTag) {
                    editItemListView
                } label: {
                    EmptyView()
                } //: NavigationLink
            } //: ZStack
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarHidden(true)
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
    
    func addItemList(to folder: Folder) -> ItemList {
        if let itemListsInSameFolders = folder.itemLists?.allObjects as? [ItemList] {
            itemListsInSameFolders.forEach { itemList in
                itemList.order += 1 
            }
        }
        var iconManager = ListIconManager()
        iconManager.loadData()
        let randomIcon = iconManager.randomCheckListIcon()
        let newItemList = folder.createNewItemList(name: K.defaultName.newItemList,
                                                   color: randomIcon.color,
                                                   primaryColor: randomIcon.primaryColor,
                                                   secondaryColor: randomIcon.secondaryColor,
                                                   iconName: randomIcon.name,
                                                   image: randomIcon.image,
                                                   order: 0, viewContext)
        saveData()
        return newItemList
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
