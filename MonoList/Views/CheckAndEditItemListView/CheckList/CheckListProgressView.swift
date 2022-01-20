//
//  CheckListProgressView.swift
//  MonoList
//
//  Created by 竹田悠真 on 2022/01/20.
//

import SwiftUI

struct CheckListProgressView: View {
    
    let numberOfCompletedItems: Int
    let numberOfAllItems: Int
    
    var completeRate: CGFloat {
        CGFloat(numberOfCompletedItems)/CGFloat(numberOfAllItems)
    }
    
    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let height = geometry.size.height
            ZStack {
                HStack(spacing: 0) {
                    Rectangle()
                        .frame(width: width * completeRate)
                        .foregroundStyle(.tint)
                    Spacer(minLength: 0)
                }
                .frame(width: width, height: height)
                .animation(.linear(duration: 0.2), value: completeRate)
                HStack {
                    Spacer()
                    Text("\(numberOfCompletedItems)/\(numberOfAllItems)")
                        .id(numberOfCompletedItems)
                }
                .animation(.none, value: numberOfCompletedItems)
                .padding(8)
            }
        }
    }
}

struct CheckListProgressView_Previews: PreviewProvider {
    static var previews: some View {
        CheckListProgressView(numberOfCompletedItems: 2, numberOfAllItems: 5)
            .previewLayout(.fixed(width: 360, height:44))
    }
}
