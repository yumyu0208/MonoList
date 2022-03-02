//
//  RichAlert.swift
//  MonoList
//
//  Created by 竹田悠真 on 2022/02/11.
//

import SwiftUI

struct RichAlert<RichAlertContent: View>: ViewModifier {
    @Binding var isShowing: Bool
    let vOffset: CGFloat
    let alertContent: RichAlertContent

    init(isShowing: Binding<Bool>, vOffset: CGFloat = 0, @ViewBuilder content: () -> RichAlertContent) {
        _isShowing = isShowing
        self.vOffset = vOffset
        self.alertContent = content()
    }

    func body(content: Content) -> some View {
        ZStack {
            content
                .disabled(isShowing)
                .zIndex(0)
            Group {
                Rectangle()
                    .foregroundColor(Color.black.opacity(0.3))
                    .ignoresSafeArea()
                    .zIndex(1)
                alertContent
                    .frame(width: 260)
                    .frame(minHeight: 170)
                    .background(Color(UIColor.secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .offset(x: 0, y: vOffset)
                    .zIndex(2)
            }
            .opacity(isShowing ? 1 : 0)
        } //: ZStack
    }
}

extension View {
  func richAlert<RichAlertContent: View>(
    isShowing: Binding<Bool>,
    vOffset: CGFloat = 0,
    @ViewBuilder content: @escaping () -> RichAlertContent
  ) -> some View {
      self.modifier(RichAlert(isShowing: isShowing, vOffset: vOffset, content: content))
  }
}

struct RichAlert_Previews: PreviewProvider {
    static var previews: some View {
        Text("")
            .richAlert(isShowing: .constant(true)) {
                VStack(spacing: 0) {
                    VStack(spacing: 0) {
                        Spacer()
                        Text("Content")
                        Spacer()
                    }
                    .frame(height: 126)
                    Divider()
                    HStack(spacing: 0) {
                        Button {
                            
                        } label: {
                            Text("Cancel")
                                .foregroundColor(.accentColor)
                        }
                        .buttonStyle(.richAlert)
                        .frame(width: 130)
                        Divider()
                        Button {
                            
                        } label: {
                            Text("OK")
                                .foregroundColor(.accentColor)
                        }
                        .buttonStyle(.richAlert)
                        .frame(width: 130)
                    } //: HStack
                    .frame(height: 44)
                }
            }
    }
}
