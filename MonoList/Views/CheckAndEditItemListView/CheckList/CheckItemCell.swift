//
//  CheckItemCell.swift
//  MonoList
//
//  Created by 竹田悠真 on 2022/01/16.
//

import SwiftUI

struct CheckItemCell: View {
    
    @ObservedObject var item: Item
    
    var body: some View {
        HStack(alignment: .top) {
            Toggle("Complete Item", isOn: $item.isCompleted)
                .toggleStyle(.checkmark)
            VStack(spacing: 0) {
                HStack {
                    Text(item.name)
                        .font(.title3)
                        .foregroundStyle(item.isCompleted ? .secondary : .primary)
                        .padding(.vertical, 6.5)
                        .animation(.easeOut(duration: 0.2), value: item.isCompleted)
                    Spacer()
                }
            }
        } //: HStack
        .contentShape(Rectangle())
        .onTapGesture {
            item.isCompleted.toggle()
        }
    }
}

struct CheckItemCell_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        let item = MonoListManager().fetchItems(context: context)[0]
        CheckItemCell(item: item)
            .padding()
            .environment(\.managedObjectContext, context)
            .previewLayout(.sizeThatFits)
    }
}
