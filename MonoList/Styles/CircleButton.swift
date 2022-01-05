//
//  circle.swift
//  MonoList
//
//  Created by 竹田悠真 on 2021/12/31.
//

import SwiftUI

struct CircleButton: ButtonStyle {
    
    enum CircleButtonType {
        case primary
        case cancel
    }
    
    var type: CircleButtonType = .primary
    
    var backgroundColor: Color {
        switch type {
        case .primary:
            return Color.accentColor
        case .cancel:
            return Color(UIColor.systemGray5)
        }
    }
    
    var foregroundColor: Color {
        switch type {
        case .primary:
            return Color.white
        case .cancel:
            return Color(UIColor.systemGray)
        }
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 12, weight: .bold, design: .rounded))
            .frame(width: 32, height: 32, alignment: .center)
            .background(backgroundColor)
            .foregroundColor(foregroundColor)
            .clipShape(Circle())
    }
}

struct CircleButton_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            Button {
                
            } label: {
                Image(systemName: "checkmark")
            }
            .buttonStyle(CircleButton(type: .primary))
            .padding()
            .previewLayout(.sizeThatFits)
            Button {
                
            } label: {
                Image(systemName: "xmark")
            }
            .buttonStyle(CircleButton(type: .cancel))
            .padding()
            .previewLayout(.sizeThatFits)
            Button {
                
            } label: {
                Image(systemName: "checkmark")
            }
            .preferredColorScheme(.dark)
            .buttonStyle(CircleButton(type: .primary))
            .padding()
            .previewLayout(.sizeThatFits)
            Button {
                
            } label: {
                Image(systemName: "xmark")
            }
            .preferredColorScheme(.dark)
            .buttonStyle(CircleButton(type: .cancel))
            .padding()
            .previewLayout(.sizeThatFits)
        }
    }
}
