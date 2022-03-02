//
//  NoListsView.swift
//  MonoList
//
//  Created by 竹田悠真 on 2022/02/23.
//

import SwiftUI

struct NoListsView: View {
    var body: some View {
        Rectangle()
            .foregroundColor(Color(UIColor.systemGroupedBackground))
            .contentShape(Rectangle())
            .overlay {
                VStack(spacing: 8) {
                    Image(systemName: "checklist")
                        .font(.title)
                    Text("No Lists")
                        .font(.body)
                }
                .foregroundColor(Color(UIColor.tertiaryLabel))
                .offset(y: -28)
            }
    }
}

struct NoListsView_Previews: PreviewProvider {
    static var previews: some View {
        NoListsView()
    }
}
