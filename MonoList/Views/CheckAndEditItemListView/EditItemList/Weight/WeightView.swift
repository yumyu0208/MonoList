//
//  WeightView.swift
//  MonoList
//
//  Created by 竹田悠真 on 2022/02/08.
//

import SwiftUI

struct WeightView: View {
    
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var itemList: ItemList
    
    var body: some View {
        ScrollView {
            HStack {
                Text("Total Weight")
                Text("\(itemList.totalWeight.string)\(itemList.unitLabel)")
            }
        } //: Scroll
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(Text("Weight"))
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                XButtonView {
                    dismiss()
                }
            }
        }
    }
}

struct WeightView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        let itemList = MonoListManager().fetchItemLists(context: context)[0]
        NavigationView {
            WeightView(itemList: itemList)
        }
    }
}
