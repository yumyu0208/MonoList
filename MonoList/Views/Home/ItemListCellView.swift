//
//  ItemListCell.swift
//  MonoList
//
//  Created by 竹田悠真 on 2022/01/08.
//

import SwiftUI

struct ItemListCellView: View {
    @AppStorage(K.key.showReviewRequest) private var showReviewRequest: Bool = false
    @AppStorage(K.key.isPlusPlan) private var isPlusPlan: Bool = false
    @Environment(\.deeplink) var deeplink
    
    let itemList: ItemList
    let editAction: () -> Void
    let duplicateAction: () -> Void
    let changeFolderAction: () -> Void
    let showInfoAction: () -> Void
    let deleteAction: () -> Void
    
    @State var itemListViewIsActive: Bool = false
    
    @State var isShowingReviewAlert = false
    
    var isNewItemList: Bool {
        itemList.name == K.defaultName.newItemList
    }
    
    var body: some View {
        NavigationLink(isActive: $itemListViewIsActive) {
            ItemListView(itemList: itemList, isEditMode: !itemList.hasItems)
                .environment(\.deeplink, deeplink)
                .onDisappear {
                    if showReviewRequest {
                        isShowingReviewAlert = true
                        showReviewRequest = false
                    }
                }
        } label: {
            HStack {
                Label {
                    Text(isNewItemList ? "New List".localized : itemList.name)
                        .font(.headline)
                        .lineLimit(1)
                        .foregroundColor(.primary)
                        .id(itemList.name)
                } icon: {
                    IconImageView(for: itemList)
                        .font(.headline)
                        .frame(height: 32)
                }
                Spacer()
                Text("\(itemList.numberOfItemsString)")
                    .font(.body)
                    .foregroundColor(.secondary)
            }
        }
        .alert("Are you satisfied with this application?", isPresented: $isShowingReviewAlert) {
            Button("No") {
                isShowingReviewAlert = false
            }
            Button("Yes") {
                isShowingReviewAlert = false
                ReviewManager.presentReviewAlert()
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
                if isPlusPlan {
                    Button(action: changeFolderAction) {
                        Label("Move", systemImage: "folder")
                    }
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
            if isPlusPlan {
                Button {
                    changeFolderAction()
                } label: {
                    Label("Move", systemImage: "folder")
                }
            }
        }
        .swipeActions(edge: .leading) {
            Button(action: duplicateAction) {
                Label("Duplicate", systemImage: "plus.rectangle.on.rectangle")
            }
            .tint(Color(itemList.color))
        }
        .onChange(of: deeplink) { deeplink in
            if let id = deeplink?.referenceId, id == itemList.id.uuidString {
                itemListViewIsActive = true
            }
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
