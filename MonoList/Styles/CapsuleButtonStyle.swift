//
//  CapsuleButtonStyle.swift
//  MonoList
//
//  Created by 竹田悠真 on 2022/01/12.
//

import SwiftUI

struct CapsuleButtonStyle: ButtonStyle {
    
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            Spacer()
            configuration.label
            Spacer()
        }
        .font(.headline.bold())
        .foregroundColor(Color(K.colors.ui.buttonLabelColor))
        .padding()
        .background(Color.accentColor)
        .clipShape(Capsule())
        .opacity(configuration.isPressed ? 0.3 : 1)
    }
}

extension ButtonStyle where Self == CapsuleButtonStyle {
    static var capsule: CapsuleButtonStyle { .init() }
}

struct CapsuleButton_Previews: PreviewProvider {
    static var previews: some View {
        Button {
            
        } label: {
            Text("Done")
        }
        .buttonStyle(.capsule)
        .padding()
        .previewLayout(.fixed(width: 360, height: 100))
    }
}
