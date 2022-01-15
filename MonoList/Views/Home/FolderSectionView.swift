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
            Label {
                Text(title)
                    .font(.title3.bold())
                    .foregroundColor(.primary)
                    .textCase(nil)
            } icon: {
                Image(systemName: image)
                    .imageScale(.large)
                    .foregroundColor(.accentColor)
            }
            .font(.headline)
            Spacer()
        } //: HStack
        .contentShape(Rectangle())
    }
}

struct FolderSectionView_Previews: PreviewProvider {
    static var previews: some View {
        FolderSectionView(image: "folder", title: "name")
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
