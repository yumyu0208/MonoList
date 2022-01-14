//
//  ItemListView.swift
//  MonoList
//
//  Created by 竹田悠真 on 2022/01/15.
//

import SwiftUI

struct ItemListView: View {
    
    @ObservedObject var itemList: ItemList
    @State var isEditMode: Bool
    
    var body: some View {
        ZStack {
            EditItemListView(of: itemList) {
                withAnimation {
                    isEditMode = false
                }
            }
            .opacity(isEditMode ? 1 : 0)
            CheckListView(of: itemList) {
                withAnimation {
                    isEditMode = true
                }
            }
            .opacity(isEditMode ? 0 : 1)
        } //: ZStack
    }
}

struct ItemListView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        let itemList = MonoListManager().fetchItemLists(context: context)[0]
        ItemListView(itemList: itemList, isEditMode: false)
            .environment(\.managedObjectContext, context)
    }
}
