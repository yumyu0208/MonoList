//
//  QuantityLabelView.swift
//  MonoList
//
//  Created by 竹田悠真 on 2022/01/14.
//

import SwiftUI

struct QuantityLabelView: View {
    
    let value: Int32
    
    var body: some View {
        
        ZStack {
            Image(systemName: "scalemass")
                .foregroundColor(.clear)
            Text(String(value))
                .foregroundColor(.primary)
        } //: ZStack
        .font(.caption.bold())
        .padding(.vertical, 4)
        .padding(.horizontal, 4)
        .background(Color.accentColor.opacity(0.5))
        .clipShape(Capsule())
    }
}

struct QuantityLabelView_Previews: PreviewProvider {
    static var previews: some View {
        QuantityLabelView(value: 12)
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
