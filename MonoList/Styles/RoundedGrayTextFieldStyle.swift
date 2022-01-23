//
//  RoundedGrayTextFieldStyle.swift
//  MonoList
//
//  Created by 竹田悠真 on 2022/01/22.
//

import SwiftUI

struct RoundedGrayTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(8)
            .background(Color(UIColor.systemGray5))
            .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

extension TextFieldStyle where Self == RoundedGrayTextFieldStyle {
    static var roundedGray: RoundedGrayTextFieldStyle { .init() }
}

struct RoundedGrayTextFieldStyle_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            TextField("Text Field", text: .constant(""))
                .textFieldStyle(.roundedGray)
                .padding()
            .previewLayout(.sizeThatFits)
            TextField("Text Field", text: .constant(""))
                .preferredColorScheme(.dark)
                .textFieldStyle(.roundedGray)
                .padding()
                .previewLayout(.sizeThatFits)
        }
    }
}
