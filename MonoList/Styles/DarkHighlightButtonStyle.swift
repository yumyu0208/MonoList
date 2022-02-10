//
//  DarkHighlightButtonView.swift
//  MonoList
//
//  Created by 竹田悠真 on 2022/02/10.
//

import SwiftUI

struct DarkHighlightButtonStyle: ButtonStyle {
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .overlay(configuration.isPressed ? Color(white: 0.5, opacity: 0.2) : .clear)
    }
}

extension ButtonStyle where Self == DarkHighlightButtonStyle {
    static var darkHighlight: DarkHighlightButtonStyle { .init() }
}

struct DarkHighlightButton_Previews: PreviewProvider {
    static var previews: some View {
        Button {
            
        } label: {
            Image(systemName: "star")
                .foregroundStyle(.blue)
                .padding()
        }
        .buttonStyle(.darkHighlight)
        .padding()
        .previewLayout(.fixed(width: 360, height: 100))
    }
}

