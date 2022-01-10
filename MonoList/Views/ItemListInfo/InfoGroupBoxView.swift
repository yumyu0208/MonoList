//
//  InfoGroupBoxView.swift
//  MonoList
//
//  Created by 竹田悠真 on 2022/01/10.
//

import SwiftUI

struct InfoGroupBoxView<Content: View>: View {
    
    let title: String
    let image: String
    let color: Color
    let value: String?
    let isActive: Bool
    let content: Content?

    init(title: String, image: String, color: Color, value: String? = nil, isActive: Bool = true, @ViewBuilder content: () -> Content? = { nil }) {
        self.title = title
        self.image = image
        self.color = color
        self.value = value
        self.isActive = isActive
        self.content = content()
    }
    
    var body: some View {
        GroupBox {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Label(title: {
                        Text(title)
                            .font(.system(.title3, design: .default))
                            .fontWeight(.bold)
                    }, icon: {
                        Image(systemName: image)
                            .font(.system(.title2, design: .default).bold())
                            .foregroundStyle(color)
                            .frame(minWidth: 32)
                    })
                    Spacer()
                    if let value = value {
                        Text(value)
                            .font(.system(.title, design: .rounded))
                            .fontWeight(.bold)
                            .foregroundColor(isActive ? .primary : .secondary)
                    }
                } //: HStack
                if let content = content {
                    content
                }
            } //: VStack
        } //: GroupBox
    }
}

extension InfoGroupBoxView where Content == EmptyView {
    init(title: String, image: String, color: Color, value: String? = nil, isActive: Bool = true) {
        self.init(title: title, image: image, color: color, value: value, isActive: isActive, content: { EmptyView() })
    }
}

struct InfoGroupBoxView_Previews: PreviewProvider {
    static var previews: some View {
        HStack {
            InfoGroupBoxView(title: "Achieve", image: "tray.2.fill", color: .pink, value: "10") {
                Text("Content")
            }
        }
        .frame(width: 358, height: 100)
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
