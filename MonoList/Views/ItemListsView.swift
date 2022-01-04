//
//  FolderListsView.swift
//  MonoList
//
//  Created by 竹田悠真 on 2022/01/04.
//

import SwiftUI

struct ItemListsView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest var itemLists: FetchedResults<ItemList>
    
    init(of folder: Folder) {
        _itemLists = FetchRequest(
            sortDescriptors: [
                SortDescriptor(\.order, order: .forward)
            ],
            predicate: NSPredicate(format: "parentFolder == %@", folder)
        )
    }
    
    var body: some View {
        ForEach(itemLists) { itemList in
            Text("\(itemList.name) - \(itemList.order)")
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
                viewContext.delete(itemLists[deleteIndex])
                if deleteIndex != itemLists.count-1 {
                    for index in deleteIndex+1 ... itemLists.count-1 {
                        itemLists[index].order -= 1
                    }
                }
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
}

struct FolderListsView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        let folder = MonoListManager().fetchFolders(context: context)[0]
        List {
            Section {
                ItemListsView(of: folder)
                    .environment(\.managedObjectContext, context)
            } header: {
                HStack(alignment: .center) {
                    FolderSectionView(image: folder.image, title: folder.name)
                }
            } //: Section
        }
    }
}
