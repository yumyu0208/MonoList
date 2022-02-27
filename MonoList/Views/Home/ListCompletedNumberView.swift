//
//  ListCompletedNumberView.swift
//  MonoList
//
//  Created by 竹田悠真 on 2022/02/27.
//

import SwiftUI

struct ListCompletedNumberView: View {
    
    
    
    var body: some View {
        Image(systemName: "checklist")
            .font(.system(size: 1300, weight: .regular, design: .rounded))
            .frame(width: 2048, height: 2048)
    }
}

struct ListCompletedNumberView_Previews: PreviewProvider {
    static var previews: some View {
        ListCompletedNumberView()
            .previewLayout(.sizeThatFits)
    }
}
