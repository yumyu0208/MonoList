//
//  ExpandToggleStyle.swift
//  MonoList
//
//  Created by 竹田悠真 on 2022/01/11.
//

import SwiftUI

struct ExpandToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        Button {
            withAnimation(.easeOut(duration: 0.2)) {
                configuration.isOn.toggle()
            }
        } label: {
            Image(systemName: "chevron.right")
                .font(.system(.title3, design: .default).weight(.semibold))
                .frame(height: 31)
                .rotationEffect(Angle(degrees: configuration.isOn ? 90 : 0))
        }
    }
}

extension ToggleStyle where Self == ExpandToggleStyle {
    static var expand: ExpandToggleStyle { .init() }
}

struct ExpandToggle_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            Toggle("Expand", isOn: .constant(false))
                .toggleStyle(.expand)
                .padding()
            .previewLayout(.sizeThatFits)
            Toggle("Expand", isOn: .constant(true))
                .toggleStyle(.expand)
                .padding()
                .previewLayout(.sizeThatFits)
        }
    }
}
