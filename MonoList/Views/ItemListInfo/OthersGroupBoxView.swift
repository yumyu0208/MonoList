//
//  OthersGroupBoxView.swift
//  MonoList
//
//  Created by 竹田悠真 on 2022/01/11.
//

import SwiftUI

struct OthersGroupBoxView: View {
    
    let itemList: ItemList
    
    var body: some View {
        InfoGroupBoxView(title: "Others",
                         image: "info.circle",
                         color: .gray,
                         canExpand: true) {
            VStack(spacing: 8) {
                HStack {
                    Label("Created", systemImage: "wand.and.stars")
                    Spacer()
                    Text(itemList.creationDateString)
                }
                HStack {
                    Label("Last Modified", systemImage: "clock.arrow.circlepath")
                    Spacer()
                    Text(itemList.lastModifiedDateString)
                }
            } //: VStack
            .padding(.leading, 4)
        } //: InfoGroupBoxView
    }
}

struct OthersGroupBoxView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        let itemList = MonoListManager().fetchItemLists(context: context)[0]
        OthersGroupBoxView(itemList: itemList)
            .environment(\.managedObjectContext, context)
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
