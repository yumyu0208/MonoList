//
//  XButtonView.swift
//  MonoList
//
//  Created by 竹田悠真 on 2022/01/22.
//

import SwiftUI

struct XButtonView: View {
    
    let action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            Image(systemName: "xmark")
                .imageScale(.medium)
                .font(.system(.headline, design: .rounded))
                .foregroundColor(Color(UIColor.systemGray))
                .padding(8)
                .background(Color(UIColor.systemGray5))
                .clipShape(Circle())
        }
    }
}

struct XButtonView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            Text("View")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        XButtonView() {}
                    }
                }
        }
    }
}
