//
//  AchievementsGroupBoxView.swift
//  MonoList
//
//  Created by 竹田悠真 on 2022/01/11.
//

import SwiftUI

struct AchievementsGroupBoxView: View {
    
    @ObservedObject var itemList: ItemList
    
    var body: some View {
        InfoGroupBoxView(value: itemList.achievementCountString,
                         title: "Achievements",
                         image: "checkmark.seal.fill",
                         color: .orange,
                         canExpand: false) {
            Text("Content")
        }
    }
}

struct AchievementsGroupBoxView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        let itemList = MonoListManager().fetchItemLists(context: context)[0]
        AchievementsGroupBoxView(itemList: itemList)
            .environment(\.managedObjectContext, context)
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
