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
    
    var body: some View {
        Text("\(numberOfCompletedItems)/\(numberOfAllItems)")
    }
}

struct CheckListProgressView_Previews: PreviewProvider {
    static var previews: some View {
        CheckListProgressView(numberOfCompletedItems: 2, numberOfAllItems: 5)
    }
}
