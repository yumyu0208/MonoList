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
                    .font(.headline)
                    .foregroundColor(.primary)
                    .textCase(nil)
            } icon: {
                if title != K.defaultName.lists {
                    Image(systemName: image)
                        .imageScale(.medium)
                        .foregroundColor(.accentColor)
                }
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
