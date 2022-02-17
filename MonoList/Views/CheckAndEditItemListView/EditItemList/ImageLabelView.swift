//
//  ImageLabelView.swift
//  MonoList
//
//  Created by 竹田悠真 on 2022/02/17.
//

import SwiftUI

struct ImageLabelView: View {
    
    var image: Image
    var scale: CGFloat
    
    var body: some View {
        image
            .resizable()
            .scaledToFill()
            .frame(width: scale, height: scale)
            .clipShape(RoundedRectangle(cornerRadius: 6, style: .continuous))
    }
}

struct ImageLabelView_Previews: PreviewProvider {
    static var previews: some View {
        ImageLabelView(image: Image("SampleImage"), scale: 36)
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
