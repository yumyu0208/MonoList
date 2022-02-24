//
//  WhiteGroupBoxStyle.swift
//  MonoList
//
//  Created by 竹田悠真 on 2022/01/12.
//

import SwiftUI

struct WhiteGroupBoxStyle: GroupBoxStyle {
    var noPadding: Bool = false
    func makeBody(configuration: Configuration) -> some View {
        configuration.content
            .frame(maxWidth: .infinity)
            .padding(noPadding ? .zeroListInsets : .defaultGroupBoxInsets)
            .background(
                Rectangle().fill(Color(UIColor.secondarySystemGroupedBackground))
            )
            .overlay(configuration.label.padding(.leading, 4), alignment: .topLeading)
            .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

extension GroupBoxStyle where Self == WhiteGroupBoxStyle {
    static var white: WhiteGroupBoxStyle { .init() }
    static var noPaddingWhite: WhiteGroupBoxStyle { .init(noPadding: true) }
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
