//
//  InfoView.swift
//  MonoList
//
//  Created by 竹田悠真 on 2022/01/13.
//

import SwiftUI

struct InfoView: View {
    
    @ObservedObject var itemList: ItemList
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                ItemsGroupBoxView(itemList: itemList)
                AchievementsGroupBoxView(itemList: itemList)
                OthersGroupBoxView(itemList: itemList)
            }
            .padding()
        } //: ScrollView
    }
}

struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        let itemList = MonoListManager().fetchItemLists(context: context)[0]
        InfoView(itemList: itemList)
            .environment(\.managedObjectContext, context)
    }
}
