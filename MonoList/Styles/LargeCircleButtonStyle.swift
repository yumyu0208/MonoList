//
//  LargeCircleButtonStyle.swift
//  MonoList
//
//  Created by 竹田悠真 on 2022/01/17.
//

import SwiftUI

struct LargeCircleButtonStyle: ButtonStyle {
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .imageScale(.large)
            .padding(12)
            .background(Circle().foregroundStyle(.tint))
            .foregroundColor(.white)
            .opacity(configuration.isPressed ? 0.3 : 1)
    }
}

extension ButtonStyle where Self == LargeCircleButtonStyle {
    static var largeCircle: LargeCircleButtonStyle { .init() }
}

struct LargeCircleButton_Previews: PreviewProvider {
    static var previews: some View {
        Button {
            
        } label: {
            Image(systemName: "checkmark")
        }
        .buttonStyle(LargeCircleButtonStyle())
        .padding()
        .previewLayout(.sizeThatFits)
    }
}

