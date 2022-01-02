//
//  circle.swift
//  MonoList
//
//  Created by 竹田悠真 on 2021/12/31.
//

import SwiftUI

struct CircleButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 12, weight: .bold, design: .rounded))
            .frame(width: 28, height: 28, alignment: .center)
            .background(Color.accentColor)
            .foregroundColor(.white)
            .clipShape(Circle())
    }
}

struct CircleButton_Previews: PreviewProvider {
    static var previews: some View {
        Button {
            
        } label: {
            Image(systemName: "checkmark")
        }
        .buttonStyle(CircleButton())
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
