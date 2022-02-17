//
//  PhotoCheckItemCell.swift
//  MonoList
//
//  Created by 竹田悠真 on 2022/02/17.
//

import SwiftUI

struct PhotoCheckItemCell: View {
    
    @ObservedObject var item: Item
    let showAndHideUndoButton: () -> Void
    let showImageViewerAction: (Image) -> Void
    
    var isCompleted: Bool {
        item.isCompleted
    }
    
    var body: some View {
        VStack {
            GeometryReader { geometry in
                if let image = item.convertedPhoto {
                    image
                        .resizable()
                        .scaledToFill()
                } else {
                    Rectangle()
                        .foregroundStyle(Color(UIColor.systemGray4))
                        .overlay {
                            Image(systemName: "tray")
                                .font(.system(.largeTitle, design: .rounded))
                                .foregroundStyle(Color(UIColor.systemGray))
                        }
                }
            }
            .aspectRatio(1, contentMode: .fit)
            .overlay {
                PhotoCheckMarkView(isCompleted: isCompleted)
            }
            .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
            .onTapGesture {
                item.isCompleted.toggle()
            }
            .onChange(of: item.isCompleted) { isCompleted in
                if isCompleted {
                    let feedBack = F.medium
                    feedBack.impactOccurred()
                    showAndHideUndoButton()
                }
            }
            .onLongPressGesture {
                if let image = item.convertedPhoto {
                    showImageViewerAction(image)
                }
            }
            Text(item.name)
                .font(.body)
                .lineLimit(1)
        } //: VStack
    }
}

