//
//  ItemsGroupBoxView.swift
//  MonoList
//
//  Created by 竹田悠真 on 2022/01/11.
//

import SwiftUI

struct ItemsGroupBoxView: View {
    
    let itemList: ItemList
    
    var body: some View {
        InfoGroupBoxView(value: itemList.numberOfItemsString,
                         title: "Items",
                         image: "tray.2.fill",
                         canExpand: itemList.hasItems) {
            VStack(alignment: .leading, spacing: 4) {
                ForEach(itemList.sortedItems) { item in
                    HStack(alignment: .top, spacing: 0) {
                        Group {
                            if item.isImportant {
                                Image(systemName: "exclamationmark")
                                    .foregroundStyle(.red)
                            } else {
                                Text(" - ")
                            }
                        }
                        .frame(width: 20)
                        Text(item.name)
                    } //: HStack
                } //: ForEach
            } //: VStack
        } //: InfoGroupBox
    }
}

struct ItemsGroupBoxView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        let itemList = MonoListManager().fetchItemLists(context: context)[0]
        ItemsGroupBoxView(itemList: itemList)
            .environment(\.managedObjectContext, context)
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
