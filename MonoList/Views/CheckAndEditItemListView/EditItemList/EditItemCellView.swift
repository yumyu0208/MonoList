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
    
    var showWeight: Bool {
        item.weight != 0
    }
    
    var showQuantity: Bool {
        item.quantity > 1
    }
    
    var body: some View {
        if item.isFault || item.isDeleted {
            EmptyView()
        } else {
            VStack(spacing: 0) {
                HStack(alignment: .center) {
                    if item.isImportant {
                        Image(systemName: "exclamationmark")
                            .font(.body.bold())
                            .foregroundColor(.red)
                            .padding(.vertical, 4)
                    }
                    ZStack {
                        TextField("", text: $item.name)
                            .font(.body)
                            .focused(focusedItem, equals: .row(id: item.id.uuidString))
                            .submitLabel(.return)
                            .padding(.vertical, 4)
                            .onSubmit {
                                if item.name.isEmpty {
                                    deleteAction(item)
                                } else {
                                    addAction(item)
                                }
                            }
                            .overlay(
                                Rectangle()
                                    .font(.body)
                                    .foregroundColor(.clear)
                                    .contentShape(Rectangle())
                                    .onTapGesture {
                                        focusedItem.wrappedValue = .row(id: item.id.uuidString)
                                    }
                            )
                    }
                    if showQuantity {
                        QuantityLabelView(value: item.quantity)
                            .onTapGesture {
                                isEditingItemDetail = true
                            }
                    }
                    Button {
                        isEditingItemDetail = true
                    } label: {
                        Image(systemName: "info.circle")
                            .imageScale(.large)
                    }
                    .buttonStyle(.plain)
                    .foregroundStyle(.tint)
                    .padding(.vertical, 4)
                } //: HStack
                VStack(spacing: 2) {
                    if showWeight {
                        HStack(alignment: .center) {
                            if let category = item.category {
                                CategoryLabelView(category: category)
                            }
                            if showWeight {
                                WeightLabelView(value: item.weight)
                            }
                            Spacer()
                            Image(systemName: "info.circle")
                                .imageScale(.large)
                                .opacity(0)
                        }
                    }
                    if let note = item.note {
                        HStack(alignment: .center) {
                            Text(note)
                                .font(.callout)
                                .foregroundStyle(.secondary)
                            Spacer()
                            Image(systemName: "info.circle")
                                .imageScale(.large)
                                .opacity(0)
                        }
                    }
                }
                .onTapGesture {
                    isEditingItemDetail = true
                }
            } //: VStack
            .padding(.leading, 8)
            .sheet(isPresented: $isEditingItemDetail) {
                NavigationView {
                    EditItemDetail(item: item)
                }
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
