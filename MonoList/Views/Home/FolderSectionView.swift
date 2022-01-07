//
//  FolderSectionView.swift
//  MonoList
//
//  Created by 竹田悠真 on 2022/01/02.
//

import SwiftUI

struct FolderSectionView: View {
    let image: String
    let title: String
    var body: some View {
        HStack {
            Group {
                Image(systemName: image)
                    .foregroundColor(.accentColor)
                Text(title)
                    .foregroundColor(.primary)
            }
            .font(.headline)
            Spacer()
        } //: HStack
    }
}

struct FolderSectionView_Previews: PreviewProvider {
    static var previews: some View {
        FolderSectionView(image: "folder", title: "name")
            .padding()
            .previewLayout(.sizeThatFits)
    }
}