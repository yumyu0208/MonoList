//
//  ImageLabelView.swift
//  MonoList
//
//  Created by 竹田悠真 on 2022/02/17.
//

import SwiftUI

struct ImageLabelView: View {
    
    var image: Image
    
    var body: some View {
        image
            .resizable()
            .scaledToFill()
            .frame(width: 36, height: 36)
            .clipShape(RoundedRectangle(cornerRadius: 6, style: .continuous))
    }
}

struct ImageLabelView_Previews: PreviewProvider {
    static var previews: some View {
        ImageLabelView(image: Image("SampleImage"))
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
