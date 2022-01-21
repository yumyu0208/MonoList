//
//  NumberView.swift
//  MonoList
//
//  Created by 竹田悠真 on 2022/01/21.
//

import SwiftUI

struct NumberView: AnimatableModifier {
    var number: Int

    var animatableData: CGFloat {
        get { CGFloat(number) }
        set { number = Int(newValue) }
    }

    func body(content: Content) -> some View {
        Text(String(number))
    }
}

extension View {
    func animation(number: Int) -> some View {
        self.modifier(NumberView(number: number))
    }
}
