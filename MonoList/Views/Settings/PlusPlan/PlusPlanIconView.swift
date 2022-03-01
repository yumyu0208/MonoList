//
//  PlusPlanIconView.swift
//  MonoList
//
//  Created by 竹田悠真 on 2022/03/01.
//

import SwiftUI

struct PlusPlanIconView: View {
    
    var size: CGFloat = 120
    
    var radius: CGFloat {
        size * 0.175
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Image(K.image.monoListIcon)
                .resizable()
                .scaledToFit()
                .frame(width: size, height: size)
                .clipShape(RoundedRectangle(cornerRadius: 21, style: .continuous))
                .shadow(color: Color(K.colors.ui.shadowColor9), radius: 8, x: 0, y: 0)
            Text("MONOLIST +")
                .font(.system(size: 28, weight: .bold))
        }
    }
}


struct PlusPlanIconView_Previews: PreviewProvider {
    static var previews: some View {
        PlusPlanIconView()
    }
}
