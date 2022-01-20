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
        
        Text(String(value))
            .foregroundColor(.white)
            .font(.caption.bold())
            .padding(.vertical, 4)
            .padding(.horizontal, 4)
            .background(.tint)
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
