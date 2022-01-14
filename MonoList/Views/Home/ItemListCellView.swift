//
//  ItemListCell.swift
//  MonoList
//
//  Created by 竹田悠真 on 2022/01/08.
//

import SwiftUI

struct ItemListCellView: View {
    
    let itemList: ItemList
    let checkListAction: () -> Void
    let editAction: () -> Void
    let duplicateAction: () -> Void
    let changeFolderAction: () -> Void
    let showInfoAction: () -> Void
    let deleteAction: () -> Void
    
    var body: some View {
        HStack {
            Button {
                checkListAction()
            } label: {
                Label {
                    Text(itemList.name)
                        .foregroundColor(.primary)
                } icon: {
                    Image(systemName: itemList.image)
                        .foregroundColor(Color(itemList.color))
                }
            } //: Button
            Spacer()
            Button {
                editAction()
            } label: {
                Image(systemName: "ellipsis")
                    .padding(.vertical, 19)
                    .padding(.trailing, 20)
                    .padding(.leading, 40)
                    .contentShape(Rectangle())
            } //: Menu
            .buttonStyle(.plain)
            .contentShape(Rectangle())
            .foregroundColor(.accentColor)
        } //: HStack
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
                changeFolderAction()
            } label: {
                Label("Move", systemImage: "folder")
            }
            .tint(.accentColor)
            Button {
                showInfoAction()
            } label: {
                Label("Info", systemImage: "info.circle")
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
                
            } editAction: {
            
            } duplicateAction: {
                
            } changeFolderAction: {
                
            } showInfoAction: {
                
            } deleteAction: {
                
            }
            .environment(\.managedObjectContext, context)
            .listRowInsets(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0))
        }
    }
}
