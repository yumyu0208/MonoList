//
//  PhotoCheckMarkView.swift
//  MonoList
//
//  Created by 竹田悠真 on 2022/02/17.
//

import SwiftUI

struct PhotoCheckMarkView: View {
    
    var isCompleted: Bool
    
    var body: some View {
        Rectangle()
            .foregroundStyle(Color(white: 0.2, opacity: 0.5))
            .overlay {
                Image(systemName: "checkmark")
                    .font(.system(.largeTitle, design: .rounded).bold())
                    .foregroundStyle(.tint)
                    .rotationEffect(.degrees(isCompleted ? 0 : 30))
                    .animation(.interpolatingSpring(mass: 1.0, stiffness: 170, damping: 15, initialVelocity: 1.0),
                               value: isCompleted)
            }
            .opacity(isCompleted ? 1 : 0)
            .animation(.easeOut(duration: 0.2), value: isCompleted)
    }
}
