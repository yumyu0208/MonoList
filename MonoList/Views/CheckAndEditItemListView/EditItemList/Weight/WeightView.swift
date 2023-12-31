//
//  WeightView.swift
//  MonoList
//
//  Created by 竹田悠真 on 2022/02/08.
//

import SwiftUI

struct WeightView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var itemList: ItemList
    
    var body: some View {
        ZStack {
            if let weightChartData = itemList.weightChartData(viewContext) {
                ScrollView {
                    PieChartView(values: weightChartData.values,
                                 names: weightChartData.names,
                                 formatter: { "\($0.string)\(itemList.unitLabel)" },
                                 colors: weightChartData.colors,
                                 images: weightChartData.images,
                                 backgroundColor: Color(UIColor.secondarySystemGroupedBackground),
                                 widthFraction: 1.0,
                                 innerRadiusFraction: 0.60)
                        .padding()
                } //: Scroll
            } else {
                NoWeightView()
            }
        }
        .navigationTitle(Text("Weight"))
        .navigationBarTitleDisplayMode(.inline)
        .background(Color(UIColor.systemGroupedBackground))
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
