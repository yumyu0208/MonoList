//
//  MiniXButtonView.swift
//  MonoList
//
//  Created by 竹田悠真 on 2022/02/12.
//

import SwiftUI

struct MiniXButtonView: View {
    
    let action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            Image(systemName: "xmark")
                .imageScale(.small)
                .font(.system(.headline, design: .rounded))
                .foregroundColor(Color(UIColor.systemGray))
                .padding(8)
                .background(Color(UIColor.systemGray5))
                .clipShape(Circle())
                .padding(6)
        }
    }
}

struct MiniXButtonView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            Text("View")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        MiniXButtonView() {}
                    }
                }
        }
    }
}
