//
//  WeightLabelView.swift
//  MonoList
//
//  Created by 竹田悠真 on 2022/01/14.
//

import SwiftUI

struct WeightLabelView: View {
    
    var value: Double
    var unitLabel: String
    
    var body: some View {
        ZStack {
            Image(systemName: "circle")
                .opacity(0)
            Text("\(value.string)\(unitLabel)")
        }
        .font(.system(.caption, design: .rounded).bold())
        .foregroundStyle(.primary)
        .padding(.vertical, 4)
        .padding(.horizontal, 8)
        .background {
            Rectangle()
                .foregroundStyle(.tint)
                .opacity(0.5)
        }
        .clipShape(Capsule())
    }
}

struct WeightLabelView_Previews: PreviewProvider {
    static var previews: some View {
        WeightLabelView(value: 230.5, unitLabel: "g")
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
