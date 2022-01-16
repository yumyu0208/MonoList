//
//  CheckmarkToggleStyle.swift
//  MonoList
//
//  Created by 竹田悠真 on 2022/01/16.
//

import SwiftUI

struct CheckmarkToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        Image(systemName: "checkmark")
            .font(.title3.bold())
            .foregroundColor(.white)
            .rotationEffect(.degrees(configuration.isOn ? 0 : 30))
            .padding(8)
            .clipShape(Rectangle().offset(x: configuration.isOn ? 0 : -60))
            .animation(.interpolatingSpring(mass: 1.0, stiffness: 170, damping: 15, initialVelocity: 1.0),
                       value: configuration.isOn)
            .contentShape(Circle())
            .background(
                ZStack {
                    // Incomplete Circle
                    Circle()
                        .stroke(style: StrokeStyle(lineWidth: 1.2,
                                                   lineCap: .round,
                                                   lineJoin: .round))
                        .foregroundStyle(.tertiary)
                        .opacity(configuration.isOn ? 0 : 1)
                    // Complete Circle
                    Circle()
                        .stroke(style: StrokeStyle(lineWidth: 1.2,
                                                   lineCap: .round,
                                                   lineJoin: .round))
                        .foregroundStyle(.tint)
                        .opacity(configuration.isOn ? 1 : 0)
                    Circle()
                        .foregroundStyle(.tint)
                        .scaleEffect(configuration.isOn ? 1 : 0)
                        .padding(2.4)
                        .animation(.interpolatingSpring(stiffness: 170, damping: 15),
                                   value: configuration.isOn)
                }
            )
            .onTapGesture {
                configuration.isOn.toggle()
            }
    }
    
}

extension ToggleStyle where Self == CheckmarkToggleStyle {
    static var checkmark: CheckmarkToggleStyle { .init() }
}

struct ContainerView: View {
    @State var isOn = true
    var body: some View {
        Toggle("Item Name", isOn: $isOn)
            .toggleStyle(.checkmark)
            .tint(.blue)
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
struct Container2View: View {
    @State var isOn = false
    var body: some View {
        Toggle("Item Name", isOn: $isOn)
            .toggleStyle(.checkmark)
        .padding()
        .previewLayout(.sizeThatFits)
    }
}

struct CheckmarkToggleStyle_Previews: PreviewProvider {
    
    static var previews: some View {
        ContainerView()
            
        Container2View()
    }
}
