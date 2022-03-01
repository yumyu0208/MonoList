//
//  InoperableView.swift
//  MonoList
//
//  Created by 竹田悠真 on 2022/02/24.
//

import SwiftUI

struct InoperableView<InoperableContent: View>: ViewModifier {
    
    let isInoperable: Bool
    let padding: EdgeInsets
    let destination: InoperableContent
    
    @State var isShowingDestination: Bool = false

    init(_ isInoperable: Bool, padding: EdgeInsets, @ViewBuilder destination: () -> InoperableContent) {
        self.isInoperable = isInoperable
        self.padding = padding
        self.destination = destination()
    }

    func body(content: Content) -> some View {
        ZStack {
            content
                .disabled(isInoperable)
                .padding(padding)
                .zIndex(0)
            if isInoperable {
                Rectangle()
                    .foregroundColor(Color.black.opacity(0.3))
                    .ignoresSafeArea()
                    .zIndex(1)
                    .fullScreenCover(isPresented: $isShowingDestination) {
                        destination
                    }
                    .onTapGesture {
                        isShowingDestination = true
                    }
            }
        } //: ZStack
        .listRowInsets(.zeroListInsets)
    }
}

extension View {
  func inoperable<InoperableContent: View>(
    _ isInoperable: Bool,
    padding: EdgeInsets,
    @ViewBuilder destination: @escaping () -> InoperableContent
  ) -> some View {
      self.modifier(InoperableView(isInoperable, padding: padding, destination: destination))
  }
}

struct InoperableView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            List {
                Rectangle()
                    .foregroundColor(.blue)
                    .inoperable(true, padding: .defaultListInsets) {
                        Text("Destination")
                    }
                    .listRowInsets(.zeroListInsets)
            }
        }
    }
}
