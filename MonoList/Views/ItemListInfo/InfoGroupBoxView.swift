//
//  InfoGroupBoxView.swift
//  MonoList
//
//  Created by 竹田悠真 on 2022/01/10.
//

import SwiftUI

struct InfoGroupBoxView<Content: View>: View {
    
    let value: String?
    let title: String
    let image: String
    let canExpand: Bool
    let content: Content?
    
    @State private var isExpanded = false

    init(value: String? = nil, title: String, image: String, canExpand: Bool = true, @ViewBuilder content: () -> Content? = { nil }) {
        self.value = value
        self.title = title
        self.image = image
        self.canExpand = canExpand
        self.content = content()
    }
    
    var body: some View {
        GroupBox {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Label(title: {
                        HStack(spacing: 4) {
                            if let value = value {
                                Text(value)
                                    .font(.system(.title3, design: .default))
                                    .fontWeight(.bold)
                            }
                            Text(title)
                                .font(.system(.title3, design: .default))
                                .fontWeight(.bold)
                        }
                    }, icon: {
                        Image(systemName: image)
                            .font(.system(.title2, design: .default).bold())
                            .foregroundStyle(.tint)
                            .frame(minWidth: 32)
                    })
                    Spacer()
                    if canExpand {
                        Toggle("Expand", isOn: $isExpanded)
                            .toggleStyle(.expand)
                            .labelsHidden()
                    }
                } //: HStack
                .contentShape(Rectangle())
                .onTapGesture {
                    if canExpand {
                        withAnimation(.easeOut(duration: 0.2)) {
                            isExpanded.toggle()
                        }
                    }
                }
                if let content = content, isExpanded {
                    content
                }
            } //: VStack
        } //: GroupBox
        .groupBoxStyle(.white)
    }
}

extension InfoGroupBoxView where Content == EmptyView {
    init(value: String? = nil, title: String, image: String, color: Color) {
        self.init(value: value, title: title, image: image, canExpand: false, content: { EmptyView() })
    }
}

struct InfoGroupBoxView_Previews: PreviewProvider {
    @State static private var isExpanded = true
    static var previews: some View {
        HStack {
            InfoGroupBoxView(value: "6", title: "Achieve", image: "tray.2.fill") {
                Text("Content")
            }
        }
        .frame(width: 358, height: 100)
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
