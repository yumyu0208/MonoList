//
//  WhiteGroupBoxStyle.swift
//  MonoList
//
//  Created by 竹田悠真 on 2022/01/12.
//

import SwiftUI

struct WhiteGroupBoxStyle: GroupBoxStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.content
            .frame(maxWidth: .infinity)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 8).fill(Color(UIColor.secondarySystemGroupedBackground))
            )
            .overlay(configuration.label.padding(.leading, 4), alignment: .topLeading)
    }
}

extension GroupBoxStyle where Self == WhiteGroupBoxStyle {
    static var white: WhiteGroupBoxStyle { .init() }
}

struct WhiteGroupBoxStyle_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            GroupBox {
                Text("Content")
            } label: {
                Text("Label")
            }
            .groupBoxStyle(.white)
            .padding()
        .previewLayout(.sizeThatFits)
            GroupBox {
                Text("Content")
            } label: {
                Text("Label")
            }
            .preferredColorScheme(.dark)
            .groupBoxStyle(.white)
            .padding()
            .previewLayout(.sizeThatFits)
        }
    }
}
