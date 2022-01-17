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
    
    var body: some View {
        HStack(alignment: .top) {
            Toggle("Complete Item", isOn: $item.isCompleted)
                .toggleStyle(.checkmark)
                .onChange(of: item.isCompleted) { isCompleted in
                    if isCompleted {
                        showAndHideUndoButton()
                    }
                }
            VStack(spacing: 0) {
                HStack(alignment: .top) {
                    if item.isImportant {
                        Image(systemName: "exclamationmark")
                            .foregroundStyle(.red)
                    }
                    if item.quantity <= 1 {
                        Text(item.name)
                            .foregroundStyle(.primary)
                    } else {
                        Text("\(item.name) × \(item.quantity)")
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
        } //: HStack
    }
}

struct CheckItemCell_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        let item = MonoListManager().fetchItems(context: context)[0]
        CheckItemCell(item: item) {}
            .padding()
            .environment(\.managedObjectContext, context)
            .previewLayout(.sizeThatFits)
    }
}
