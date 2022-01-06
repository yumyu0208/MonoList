//
//  EditItemCellView.swift
//  MonoList
//
//  Created by 竹田悠真 on 2022/01/05.
//

import SwiftUI

struct EditItemCellView: View {
    
    @ObservedObject var item: Item
    
    @State var isEditingItemDetail = false
    var focusedItem: FocusState<Focusable?>.Binding
    let deleteAction: (Item) -> Void
    let addAction: (Item) -> Void
    
    var isFocused: Bool {
        focusedItem.wrappedValue == .row(id: item.id.uuidString)
    }
    
    var body: some View {
        HStack {
            if item.isFault {
                EmptyView()
            } else {
                if item.isImportant {
                    Image(systemName: "exclamationmark")
                        .font(.body.bold())
                        .foregroundColor(.red)
                }
                Text("\(item.order)")
                TextField("", text: $item.name)
                    .focused(focusedItem, equals: .row(id: item.id.uuidString))
                    .submitLabel(.return)
                    .onSubmit {
                        if item.name.isEmpty {
                            deleteAction(item)
                        } else {
                            addAction(item)
                        }
                    }
                if isFocused {
                    Button {
                        isEditingItemDetail = true
                    } label: {
                        Image(systemName: "info.circle")
                    }
                    .buttonStyle(.plain)
                    .foregroundColor(.accentColor)
                }
            }
        } //: HStack
        .padding(.leading, 8)
        .sheet(isPresented: $isEditingItemDetail) {
            Text("Edit Item Detail")
        }
    }
}

struct EditItemCellView_Previews: PreviewProvider {
    @FocusState static var focusedItem: Focusable?
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        let items = MonoListManager().fetchItems(context: context)
        List {
            ForEach(0 ..< 5) { index in
                EditItemCellView(item: items[index], focusedItem: $focusedItem, deleteAction: {_ in }, addAction: {_ in })
                    .environment(\.managedObjectContext, context)
            }
            .onDelete { _ in }
            .onMove { _, _ in }
        }
        .listStyle(.plain)
    }
}
