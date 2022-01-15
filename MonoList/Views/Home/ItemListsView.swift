//
//  FolderListsView.swift
//  MonoList
//
//  Created by 竹田悠真 on 2022/01/04.
//

import SwiftUI

struct ItemListsView: View {
    @EnvironmentObject var manager: MonoListManager
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest var itemLists: FetchedResults<ItemList>
    
    @State var showingInfoItemList: ItemList?
    @State var movingItemList: ItemList?
    let editAction: (ItemList) -> Void
    
    init(of folder: Folder, editAction: @escaping (ItemList) -> Void) {
        
        _itemLists = FetchRequest(
            sortDescriptors: [
                SortDescriptor(\.order, order: .forward)
            ],
            predicate: NSPredicate(format: "parentFolder == %@", folder)
        )
        self.editAction = editAction
    }
    
    var body: some View {
        ForEach(itemLists) { itemList in
            ItemListCellView(itemList: itemList) {
                editAction(itemList)
            } duplicateAction: {
                duplicateItemList(itemList)
            } changeFolderAction: {
                movingItemList = itemList
            } showInfoAction: {
                showingInfoItemList = itemList
            } deleteAction: {
                if let index = itemLists.firstIndex(of: itemList) {
                    deleteItemLists(offsets: IndexSet(integer: index))
                }
            }
            .sheet(item: $showingInfoItemList) { itemList in
                NavigationView {
                    AllInfoView(itemList: itemList)
                }
            }
            .sheet(item: $movingItemList) { itemList in
                NavigationView {
                    SelectDestinationView(itemList: itemList) { itemList, destinationFolder in
                        moveItemList(itemList, to: destinationFolder)
                    }
                    .environmentObject(manager)
                }
            }
        }
        .onDelete(perform: deleteItemLists)
        .onMove(perform: moveitemList)
    }
    
    private func saveData() {
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    private func deleteItemLists(offsets: IndexSet) {
        withAnimation {
            offsets.forEach { deleteIndex in
                ItemList.delete(index: deleteIndex, itemLists: itemLists, viewContext)
            }
            saveData()
        }
    }
    
    private func moveitemList(indexSet: IndexSet, destination: Int) {
        withAnimation {
            indexSet.forEach { source in
                if source < destination {
                    var startIndex = source + 1
                    let endIndex = destination - 1
                    var startOrder = itemLists[source].order
                    while startIndex <= endIndex {
                        itemLists[startIndex].order = startOrder
                        startOrder += 1
                        startIndex += 1
                    }
                    itemLists[source].order = startOrder
                } else if destination < source {
                    var startIndex = destination
                    let endIndex = source - 1
                    var startOrder = itemLists[destination].order + 1
                    let newOrder = itemLists[destination].order
                    while startIndex <= endIndex {
                        itemLists[startIndex].order = startOrder
                        startOrder += 1
                        startIndex += 1
                    }
                    itemLists[source].order = newOrder
                }
                saveData()
            }
        }
    }
    
    private func moveItemList(_ itemList: ItemList, to folder: Folder) {
        withAnimation {
            let deleteIndex = itemLists.firstIndex(of: itemList) ?? 0
            if deleteIndex != itemLists.count-1 {
                for index in deleteIndex+1 ..< itemLists.count {
                    itemLists[index].order -= 1
                }
            }
            itemList.parentFolder.removeFromItemLists(itemList)
            itemList.order = Int32(folder.itemLists?.count ?? 0)
            folder.addToItemLists(itemList)
            saveData()
        }
    }
    
    func duplicateItemList(_ sourceItemList: ItemList) {
        withAnimation {
            guard let indexOfSource = itemLists.firstIndex(of: sourceItemList) else { return }
            sourceItemList.duplicate(viewContext)
            for index in indexOfSource + 1 ..< itemLists.count {
                itemLists[index].order += 1
            }
            saveData()
        }
    }
}

struct FolderListsView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        let folder = MonoListManager().fetchFolders(context: context)[0]
        List {
            Section {
                ItemListsView(of: folder) { _ in }
                    .environment(\.managedObjectContext, context)
            } header: {
                HStack(alignment: .center) {
                    FolderSectionView(image: folder.image, title: folder.name)
                }
            } //: Section
        }
    }
}
