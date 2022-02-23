//
//  NoWeightView.swift
//  MonoList
//
//  Created by 竹田悠真 on 2022/02/23.
//

import SwiftUI

struct NoWeightView: View {
    var body: some View {
        Rectangle()
            .foregroundColor(Color(UIColor.systemGroupedBackground))
            .contentShape(Rectangle())
            .overlay {
                VStack(spacing: 8) {
                    Image(systemName: "scalemass")
                        .font(.largeTitle)
                    Text("No Weight")
                        .font(.title3)
                }
                .foregroundColor(Color(UIColor.tertiaryLabel))
                .offset(y: -28)
            }
    }
}

struct NoWeightView_Previews: PreviewProvider {
    static var previews: some View {
        NoWeightView()
    }
}
