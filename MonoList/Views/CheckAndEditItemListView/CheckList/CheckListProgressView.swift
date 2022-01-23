//
//  CheckListProgressView.swift
//  MonoList
//
//  Created by 竹田悠真 on 2022/01/20.
//

import SwiftUI

struct CheckListProgressView: View {
    
    @AppStorage(K.key.rateDisplayType) var showPercentage = true
    @State private var percentage: Int = 0
    let numberOfCompletedItems: Int
    let numberOfAllItems: Int
    
    var completeRate: CGFloat {
        if numberOfAllItems != 0 {
            return CGFloat(numberOfCompletedItems)/CGFloat(numberOfAllItems)
        } else { return 0 }
    }
    
    var completePercentage: Int {
        Int((completeRate*100).rounded())
    }
    
    var body: some View {
        ZStack(alignment: .center) {
            HStack {
                Spacer()
                if showPercentage {
                    HStack(spacing: 0) {
                        Text("\(percentage)")
                            .animation(number: percentage)
                            .multilineTextAlignment(.trailing)
                            .onChange(of: completePercentage) { newValue in
                                withAnimation {
                                    percentage = newValue
                                }
                        }
                        Text("%")
                    }
                } else {
                    HStack(spacing: 0) {
                        Text("\(numberOfCompletedItems)")
                            .multilineTextAlignment(.trailing)
                            .id(numberOfCompletedItems)
                        Text("/\(numberOfAllItems)")
                            .multilineTextAlignment(.trailing)
                    }
                }
            } //: HStack
            .font(.system(.headline, design: .rounded))
            .foregroundStyle(.tint)
            .padding(.horizontal)
            .padding(.vertical, 4)
            .background(
                GeometryReader { geometry in
                    let width = geometry.size.width
                    ZStack {
                        HStack(spacing: 0) {
                            Rectangle()
                                .frame(width: width * completeRate)
                                .foregroundStyle(.tint)
                                .opacity(0.3)
                            Spacer(minLength: 0)
                        }
                        .animation(.easeOut(duration: 0.2), value: completeRate)
                    }
                }
            )
            .contentShape(Rectangle())
            .onTapGesture {
                percentage = completePercentage
                withAnimation {
                    showPercentage.toggle()
                }
            }
        } //: ZStack
        .onAppear {
            percentage = completePercentage
        }
    }
}

struct CheckListProgressView_Previews: PreviewProvider {
    static var previews: some View {
        CheckListProgressView(numberOfCompletedItems: 2, numberOfAllItems: 5)
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
