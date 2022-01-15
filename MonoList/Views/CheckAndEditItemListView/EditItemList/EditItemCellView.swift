//
//  EditItemCellView.swift
//  MonoList
//
//  Created by 竹田悠真 on 2022/01/05.
//

import SwiftUI

struct EditItemCellView: View, Equatable {
    
    static func == (lhs: EditItemCellView, rhs: EditItemCellView) -> Bool {
        lhs.item == rhs.item
    }
    
    @ObservedObject var item: Item
    
    @State var isEditingItemDetail = false
    var focusedItem: FocusState<Focusable?>.Binding
    let deleteAction: (Item) -> Void
    let addAction: (Item) -> Void
    
    var body: some View {
        HStack {
            if item.isFault || item.isDeleted {
                EmptyView()
            } else {
                Text("\(item.order)")
                if item.isImportant {
                    Image(systemName: "exclamationmark")
                        .font(.body.bold())
                        .foregroundColor(.red)
                }
                ZStack {
                    TextField("", text: $item.name)
                        .font(.body)
                        .focused(focusedItem, equals: .row(id: item.id.uuidString))
                        .submitLabel(.return)
                        .onSubmit {
                            if item.name.isEmpty {
                                deleteAction(item)
                            } else {
                                addAction(item)
                            }
                        }
                    Rectangle()
                        .foregroundColor(.clear)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            focusedItem.wrappedValue = .row(id: item.id.uuidString)
                        }
                }
                if item.weight != 0 {
                    WeightLabelView(value: item.weight)
                }
                if item.quantity > 1 {
                    QuantityLabelView(value: item.quantity)
                }
                Button {
                    isEditingItemDetail = true
                } label: {
                    Image(systemName: "info.circle")
                        .imageScale(.large)
                }
                .buttonStyle(.plain)
                .foregroundColor(.accentColor)
            }
        } //: HStack
        .padding(.leading, 8)
        .sheet(isPresented: $isEditingItemDetail) {
            NavigationView {
                EditItemDetail(item: item)
            }
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
