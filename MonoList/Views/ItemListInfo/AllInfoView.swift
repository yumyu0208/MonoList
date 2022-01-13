//
//  ItemListInfoView.swift
//  MonoList
//
//  Created by 竹田悠真 on 2022/01/10.
//

import SwiftUI

struct AllInfoView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var editMode: EditMode = .inactive
    @ObservedObject var itemList: ItemList
    
    var body: some View {
        ScrollView {
            VStack {
                ListTitleView(itemList: itemList)
                    .environment(\.editMode, $editMode)
                VStack(spacing: 20) {
                    ItemsGroupBoxView(itemList: itemList)
                    NotificationsGroupBoxView(itemList: itemList)
                        .environment(\.editMode, $editMode)
                    AchievementsGroupBoxView(itemList: itemList)
                    OthersGroupBoxView(itemList: itemList)
                }
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarTitle(Text("List Info"))
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                }
                .buttonStyle(CircleButtonStyle(type: .cancel))
            } // :ToolBarItem
        }
        .background(
            Color(UIColor.systemGroupedBackground)
                .ignoresSafeArea(.all, edges: .all)
        )
    }
}

struct ItemListInfoView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        let itemList = MonoListManager().fetchItemLists(context: context)[0]
        NavigationView {
            AllInfoView(itemList: itemList)
                .environment(\.managedObjectContext, context)
        }
    }
}
