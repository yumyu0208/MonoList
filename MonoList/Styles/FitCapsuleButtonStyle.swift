//
//  FitCapsuleButtonStyle.swift
//  MonoList
//
//  Created by 竹田悠真 on 2022/02/12.
//

import SwiftUI

struct FitCapsuleButtonStyle: ButtonStyle {
    
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label
        }
        .frame(minWidth: 120)
        .font(.headline.bold())
        .foregroundColor(Color(K.colors.ui.buttonLabelColor))
        .padding()
        .background(Color.accentColor)
        .clipShape(Capsule())
        .opacity(configuration.isPressed ? 0.3 : 1)
    }
}

extension ButtonStyle where Self == FitCapsuleButtonStyle {
    static var fitCapsule: FitCapsuleButtonStyle { .init() }
}

struct FitCapsuleButton_Previews: PreviewProvider {
    static var previews: some View {
        Button {
            
        } label: {
            Text("Done")
        }
        .buttonStyle(.fitCapsule)
        .padding()
        .previewLayout(.fixed(width: 360, height: 100))
    }
}
