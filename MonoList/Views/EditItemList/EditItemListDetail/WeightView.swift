//
//  WeightView.swift
//  MonoList
//
//  Created by 竹田悠真 on 2022/01/13.
//

import SwiftUI

struct WeightView: View {
    
    @ObservedObject var itemList: ItemList
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("Weight Group Box")
            }
            .padding()
        } //: ScrollView
    }
}

struct WeightView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        let itemList = MonoListManager().fetchItemLists(context: context)[0]
        WeightView(itemList: itemList)
            .environment(\.managedObjectContext, context)
    }
}
