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
    var showPlusButton: Bool = false
    
    let addItemListAction: () -> Void
    
    var isMyListFolder: Bool {
        title == K.defaultName.lists
    }
    var body: some View {
        HStack {
            Label {
                Text(isMyListFolder ? "My Lists".localized : title)
                    .font(.headline)
                    .foregroundColor(.primary)
                    .textCase(nil)
            } icon: {
                if !isMyListFolder {
                    Image(systemName: image)
                        .imageScale(.medium)
                        .foregroundColor(.accentColor)
                }
            }
            .font(.headline)
            Spacer()
            Button {
                addItemListAction()
            } label: {
                Image(systemName: "plus")
                    .font(.headline)
                    .padding(8)
            }
            .opacity(showPlusButton ? 1 : 0)
        } //: HStack
        .contentShape(Rectangle())
        .padding(.trailing, 8)
    }
}

struct FolderSectionView_Previews: PreviewProvider {
    static var previews: some View {
        FolderSectionView(image: "folder", title: "name") {}
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
