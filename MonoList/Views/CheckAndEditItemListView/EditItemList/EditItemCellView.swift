//
//  EditItemCellView.swift
//  MonoList
//
//  Created by 竹田悠真 on 2022/01/05.
//

import SwiftUI

struct EditItemCellView: View, Equatable {
    @Environment(\.deeplink) var deeplink
    static func == (lhs: EditItemCellView, rhs: EditItemCellView) -> Bool {
        lhs.item == rhs.item
    }
    
    @ObservedObject var item: Item
    
    @State var isEditingItemDetail = false
    var focusedItem: FocusState<Focusable?>.Binding
    let deleteAction: (Item) -> Void
    let addAction: (Item) -> Void
    let dismissKeyboardAction: () -> Void
    
    var parentList: ItemList {
        item.parentItemList
    }
    
    var showWeight: Bool {
        !parentList.weightIsHidden && item.weight != 0
    }
    
    var showQuantity: Bool {
        !parentList.quantityIsHidden && item.quantity > 1
    }
    
    var showCategory: Bool {
        !parentList.categoryIsHidden
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
                    if showWeight {
                        WeightLabelView(value: item.weight, unitLabel: item.parentItemList.unitLabel)
                            .onTapGesture {
                                dismissKeyboardAction()
                                isEditingItemDetail = true
                            }
                    }
                    if showQuantity {
                        QuantityLabelView(value: item.quantity)
                            .onTapGesture {
                                dismissKeyboardAction()
                                isEditingItemDetail = true
                            }
                    }
                    Button {
                        if item.name.isEmpty {
                            item.name = "New Item".localized
                        }
                        isEditingItemDetail = true
                        dismissKeyboardAction()
                    } label: {
                        Image(systemName: "info.circle")
                            .imageScale(.large)
                    }
                    .buttonStyle(.plain)
                    .foregroundStyle(.tint)
                    .padding(.vertical, 4)
                } //: HStack
                if item.note != nil || (showCategory&&item.category != nil) || item.convertedPhoto != nil {
                    VStack(spacing: 4) {
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
                        if showCategory, let category = item.category {
                            HStack(alignment: .center) {
                                CategoryLabelView(category: category)
                                    .id(category.stateId)
                                Spacer()
                                Image(systemName: "info.circle")
                                    .imageScale(.large)
                                    .opacity(0)
                            }
                        }
                        if let image = item.convertedPhoto {
                            HStack(alignment: .center) {
                                ImageLabelView(image: image, scale: 36)
                                Spacer()
                                Image(systemName: "info.circle")
                                    .imageScale(.large)
                                    .opacity(0)
                            }
                        }
                    } //: VStack
                    .padding(.bottom, 4)
                    .onTapGesture {
                        dismissKeyboardAction()
                        isEditingItemDetail = true
                    }
                }
            } //: VStack
            .padding(.leading, 8)
            .sheet(isPresented: $isEditingItemDetail) {
                NavigationView {
                    EditItemDetail(item: item)
                        .environment(\.deeplink, deeplink)
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
                EditItemCellView(item: items[index], focusedItem: $focusedItem, deleteAction: {_ in }, addAction: {_ in }, dismissKeyboardAction: {})
                    .environment(\.managedObjectContext, context)
            }
            .onDelete { _ in }
            .onMove { _, _ in }
        }
        .listStyle(.plain)
    }
}
