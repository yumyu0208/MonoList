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
                    Text("2021/1/10 13:30")
                }
                HStack {
                    Label("Last Modified", systemImage: "clock.arrow.circlepath")
                    Spacer()
                    Text("Today")
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
