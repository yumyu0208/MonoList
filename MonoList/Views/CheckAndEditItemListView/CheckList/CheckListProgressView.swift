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
        .background(
            HStack {
                GeometryReader { geometry in
                    let width = geometry.size.width
                    VStack {
                        Spacer(minLength: 0)
                        HStack(spacing: 0) {
                            Rectangle()
                                .frame(width: width * completeRate)
                                .foregroundStyle(.tint)
                            Spacer(minLength: 0)
                        }
                        .frame(height: 8)
                        .background(Color(UIColor.systemGray5))
                        .clipShape(Capsule())
                        .animation(.easeOut(duration: 0.2), value: completeRate)
                        Spacer(minLength: 0)
                    }
                }
                Text("000%")
                    .opacity(0)
            } //: HStack
        )
        .padding(.horizontal)
        .padding(.vertical, 4)
        .contentShape(Rectangle())
        .onTapGesture {
            percentage = completePercentage
            withAnimation {
                showPercentage.toggle()
            }
        }
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
