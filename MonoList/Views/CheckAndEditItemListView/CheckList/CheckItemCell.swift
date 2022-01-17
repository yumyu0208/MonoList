//
//  CheckItemCell.swift
//  MonoList
//
//  Created by 竹田悠真 on 2022/01/16.
//

import SwiftUI

struct CheckItemCell: View {
    
    @ObservedObject var item: Item
    @State private var isOn: Bool = false
    @State private var timer: Timer? = Timer()
    
    var body: some View {
        HStack(alignment: .top) {
            Toggle("Complete Item", isOn: $isOn)
                .toggleStyle(.checkmark)
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
            .opacity(isOn ? 0.4 : 1)
        } //: HStack
        .onAppear {
            isOn = item.isCompleted
        }
        .onChange(of: isOn) { isOn in
            if isOn {
                timer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { _ in
                    item.isCompleted = true
                }
            } else {
                if let timer = timer {
                    timer.invalidate()
                }
                item.isCompleted = false
            }
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
