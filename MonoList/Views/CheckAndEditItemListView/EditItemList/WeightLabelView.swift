//
//  WeightLabelView.swift
//  MonoList
//
//  Created by 竹田悠真 on 2022/01/14.
//

import SwiftUI

struct WeightLabelView: View {
    @AppStorage(K.key.weightUnit) var weightUnit = "g"
    let value: Double
    
    var body: some View {
        ZStack {
            Image(systemName: "circle")
                .opacity(0)
            Text("\(value.string)\(weightUnit)")
        }
            .font(.caption.bold())
            .foregroundColor(.white)
            .padding(.vertical, 4)
            .padding(.horizontal, 8)
            .background(.tint)
            .clipShape(Capsule())
    }
}

struct WeightLabelView_Previews: PreviewProvider {
    static var previews: some View {
        WeightLabelView(value: 230.5)
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
