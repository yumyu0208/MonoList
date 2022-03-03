//
//  ContentView.swift
//  MonoList
//
//  Created by 竹田悠真 on 2021/12/25.
//

import SwiftUI
import CoreData

struct HomeView: View {
    @AppStorage(K.key.isInitialLaunch) private var isInitialLaunch: Bool = true
    @AppStorage(K.key.isPlusPlan) private var isPlusPlan: Bool = false
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.deeplink) var deeplink
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
    
    var noList: Bool {
        folders.count == 1 && folders.first?.itemLists?.count == 0
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
                            Image(systemName: "checkmark.circle.fill")
                        }
                        .font(.system(.title2, design: .default).bold())
                        .labelStyle(.titleAndIcon)
                        Spacer()
                        Group {
                            EditLabelView(imageOnly: true)
                                .disabled(noList)
                                .environment(\.editMode, $editMode)
                            Button {
                                isShowingSettings = true
                            } label: {
                                Label("Settings", systemImage: "gearshape")
                                    .padding(8)
                                    .animation(.none, value: isEditing)
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
                    ZStack {
                        if !noList {
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
                        } else {
                            NoListsView()
                        }
                    }
                    .overlay(alignment: .bottom) {
                        if !isPlusPlan {
                            BannerAdView(adUnit: .homeBottomBanner, adFormat: .adaptiveBanner)
                        }
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
                                newListAction()
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
                .animation(.default, value: noList)
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
            if isInitialLaunch && folders.isEmpty {
                MonoListData.loadData(from: .sample, viewContext)
            }
            isInitialLaunch = false
            manager.orderFolder(context: viewContext)
            saveData()
            NotificationManager().checkNotificationSettings(viewContext)
        }
        .onReceive(willTerminateObserver) { _ in
            saveData()
        }
        .onChange(of: deeplink) { deeplink in
            if deeplink != nil {
                isSortingFolders = false
                isShowingSettings = false
                editMode = .inactive
                if deeplink == .newList {
                    newListAction()
                }
            }
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
    
    func newListAction() {
        if let defaultFolder = folders.first {
            withAnimation {
                let newItemList = addItemList(to: defaultFolder)
                editItemListView = ItemListView(itemList: newItemList, isEditMode: true)
                navigationLinkTag = editItemListTag
            }
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
