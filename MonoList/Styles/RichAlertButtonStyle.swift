//
//  RichAlertButtonStyle.swift
//  MonoList
//
//  Created by 竹田悠真 on 2022/02/11.
//

import SwiftUI

struct RichAlertButtonStyle: ButtonStyle {
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .overlay(configuration.isPressed ? Color(white: 0.5, opacity: 0.2) : .clear)
            .contentShape(Rectangle())
    }
}

extension ButtonStyle where Self == RichAlertButtonStyle {
    static var richAlert: RichAlertButtonStyle { .init() }
}

struct RichAlertButton_Previews: PreviewProvider {
    static var previews: some View {
        Button {
            
        } label: {
            Text("OK")
                .foregroundColor(.accentColor)
        }
        .buttonStyle(.richAlert)
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
