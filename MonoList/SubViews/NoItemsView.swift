//
//  NoItemsView.swift
//  MonoList
//
//  Created by 竹田悠真 on 2022/01/21.
//

import SwiftUI

struct NoItemsView: View {
    var body: some View {
        Rectangle()
            .foregroundColor(.clear)
            .contentShape(Rectangle())
            .overlay {
                VStack(spacing: 8) {
                    Image(systemName: "tray")
                        .font(.title)
                    Text("No Items")
                        .font(.body)
                }
                .foregroundColor(Color(UIColor.tertiaryLabel))
                .offset(y: -28)
            }
    }
}

struct NoItemsView_Previews: PreviewProvider {
    static var previews: some View {
        NoItemsView()
    }
}
