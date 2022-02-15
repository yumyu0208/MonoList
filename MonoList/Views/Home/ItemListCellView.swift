//
//  ItemListCell.swift
//  MonoList
//
//  Created by 竹田悠真 on 2022/01/08.
//

import SwiftUI

struct ItemListCellView: View {
    
    let itemList: ItemList
    let editAction: () -> Void
    let duplicateAction: () -> Void
    let changeFolderAction: () -> Void
    let showInfoAction: () -> Void
    let deleteAction: () -> Void
    
    var isNewItemList: Bool {
        itemList.name == K.defaultName.newItemList
    }
    
    var body: some View {
        NavigationLink {
            ItemListView(itemList: itemList, isEditMode: !itemList.hasItems)
        } label: {
            HStack {
                Label {
                    Text(isNewItemList ? "New List" : itemList.name)
                        .font(.headline)
                        .foregroundColor(.primary)
                        .id(itemList.name)
                } icon: {
                    IconImageView(for: itemList)
                        .font(.headline)
                        .frame(height: 32)
                }
                Spacer()
                Text(itemList.numberOfItemsString)
                    .font(.body)
                    .foregroundColor(.secondary)
            }
        }
        .contextMenu {
            Section {
                Button(action: editAction) {
                    Label("Edit", systemImage: "pencil")
                }
                Button(action: duplicateAction) {
                    Label("Duplicate", systemImage: "plus.rectangle.on.rectangle")
                }
                Button(action: changeFolderAction) {
                    Label("Move", systemImage: "folder")
                }
                Button(action: showInfoAction) {
                    Label("Info", systemImage: "info.circle")
                }
            }
            Section {
                Button(role: .destructive, action: deleteAction) {
                    Label("Delete", systemImage: "trash")
                }
            }
        }
        .swipeActions(edge: .trailing) {
            Button(role: .destructive) {
                deleteAction()
            } label: {
                Label("Delete", systemImage: "trash")
            }
            Button {
                editAction()
            } label: {
                Label("Edit", systemImage: "pencil")
            }
            .tint(.orange)
            Button {
                changeFolderAction()
            } label: {
                Label("Move", systemImage: "folder")
            }
        }
        .swipeActions(edge: .leading) {
            Button(action: duplicateAction) {
                Label("Duplicate", systemImage: "plus.rectangle.on.rectangle")
            }
            .tint(.mint)
        }
    }
}

struct ItemListCellView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        let itemList = MonoListManager().fetchItemLists(context: context)[0]
        List {
            ItemListCellView(itemList: itemList) {
            
            } duplicateAction: {
                
            } changeFolderAction: {
                
            } showInfoAction: {
                
            } deleteAction: {
                
            }
            .environment(\.managedObjectContext, context)
        }
    }
}
