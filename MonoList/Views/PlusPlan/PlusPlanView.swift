//
//  PlusPlunView.swift
//  MonoList
//
//  Created by 竹田悠真 on 2022/02/24.
//

import SwiftUI

struct PlusPlanView: View {
    
    enum FeatureType {
        case removeAds
        case category
        case quantity
        case weight
        case catalog
        case alarm
        static var all = [removeAds, category, quantity, weight, catalog, alarm]
    }
    
    @Environment(\.dismiss) private var dismiss
    
    @State var featureType: FeatureType = .removeAds
    
    var body: some View {
        Text("Hello World")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    XButtonView {
                        dismiss()
                    }
                }
            }
    }
}

struct PlusPlunView_Previews: PreviewProvider {
    static var previews: some View {
        PlusPlanView()
    }
}
