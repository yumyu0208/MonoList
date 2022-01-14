//
//  WeightLabelView.swift
//  MonoList
//
//  Created by 竹田悠真 on 2022/01/14.
//

import SwiftUI

struct WeightLabelView: View {
    
    let value: Double
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: "scalemass")
                .font(.caption.bold())
            Text(value.string)
        }
        .font(.caption.bold())
        .foregroundColor(.primary)
        .padding(.vertical, 4)
        .padding(.horizontal, 8)
        .background(Color.accentColor.opacity(0.5))
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
