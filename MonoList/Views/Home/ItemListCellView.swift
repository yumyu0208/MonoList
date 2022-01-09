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
    
    var body: some View {
        HStack {
            Button {
                editAction()
            } label: {
                Label {
                    Text("\(itemList.order) \(itemList.name)")
                        .foregroundColor(.primary)
                } icon: {
                    Image(systemName: itemList.image)
                        .foregroundColor(Color(itemList.color))
                }
            } //: Button
            Spacer()
            Menu {
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
            } label: {
                Image(systemName: "ellipsis")
                    .padding(.vertical, 13)
                    .padding(.horizontal, 20)
            } primaryAction: {
                editAction()
            } //: Menu
            .menuStyle(.borderlessButton)
            .contentShape(Rectangle())
            .foregroundColor(.accentColor)
        } //: HStack
        .listRowInsets(EdgeInsets(top: 6, leading: 20, bottom: 6, trailing: 0))
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
