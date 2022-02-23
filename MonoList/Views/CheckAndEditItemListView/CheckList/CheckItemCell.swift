//
//  CheckItemCell.swift
//  MonoList
//
//  Created by 竹田悠真 on 2022/01/16.
//

import SwiftUI

struct CheckItemCell: View {
    
    @ObservedObject var item: Item
    let showAndHideUndoButton: () -> Void
    let showImageViewerAction: (Image) -> Void
    
    var parentList: ItemList {
        item.parentItemList
    }
    
    var showQuantity: Bool {
        !parentList.quantityIsHidden && item.quantity > 1
    }
    
    var body: some View {
        HStack(alignment: .top) {
            Toggle("Complete Item", isOn: $item.isCompleted)
                .toggleStyle(.checkmark)
                .onChange(of: item.isCompleted) { isCompleted in
                    if isCompleted {
                        let feedBack = F.medium
                        feedBack.prepare()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            feedBack.impactOccurred()
                        }
                        showAndHideUndoButton()
                    }
                }
            VStack(spacing: 0) {
                HStack(alignment: .top) {
                    if item.isImportant {
                        Image(systemName: "exclamationmark")
                            .foregroundStyle(.red)
                    }
                    if showQuantity {
                        Text("\(item.name) × \(item.quantity)")
                            .foregroundStyle(.primary)
                    } else {
                        Text(item.name)
                            .foregroundStyle(.primary)
                    }
                    Spacer()
                } //: HStack
                .font(.title3)
                .padding(.vertical, 6.5)
                if let note = item.note {
                    HStack {
                        Text(note)
                            .font(.body)
                            .foregroundStyle(.secondary)
                        Spacer()
                    }
                }
            } //: VStack
            .opacity(item.isCompleted ? 0.4 : 1)
            .animation(.none, value: item.isCompleted)
            if let image = item.convertedPhoto {
                Toggle("Complete Item", isOn: .constant(false))
                    .toggleStyle(.checkmark)
                    .opacity(0)
                    .overlay {
                        ImageLabelView(image: image, scale: 48)
                            .opacity(item.isCompleted ? 0.4 : 1)
                            .animation(.none, value: item.isCompleted)
                            .onTapGesture {
                                showImageViewerAction(image)
                            }
                    }
            }
        } //: HStack
    }
}

struct CheckItemCell_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        let item = MonoListManager().fetchItems(context: context)[0]
        CheckItemCell(item: item, showAndHideUndoButton: {}, showImageViewerAction: { _ in })
            .padding()
            .environment(\.managedObjectContext, context)
            .previewLayout(.sizeThatFits)
    }
}
