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
    
    let deleteAction: (Item) -> Void
    let addAction: (Item) -> Void
    
    var body: some View {
        HStack {
            if item.isImportant {
                Image(systemName: "exclamationmark")
                    .font(.body.bold())
                    .foregroundColor(.red)
            }
            Text("\(item.order)")
            TextField("", text: $item.name)
                .submitLabel(.return)
                .onSubmit {
                    if item.name.isEmpty {
                        deleteAction(item)
                    } else {
                        addAction(item)
                    }
                }
            Button {
                isEditingItemDetail = true
            } label: {
                Image(systemName: "info.circle")
            }
            .buttonStyle(.plain)
            .foregroundColor(.accentColor)
        }
        .padding(.leading, 8)
        .sheet(isPresented: $isEditingItemDetail) {
            Text("Edit Item Detail")
        }
    }
}

struct EditItemCellView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        let items = MonoListManager().fetchItems(context: context)
        List {
            ForEach(0 ..< 5) { index in
                EditItemCellView(item: items[index], deleteAction: {_ in }, addAction: {_ in })
                    .environment(\.managedObjectContext, context)
            }
            .onDelete { _ in }
            .onMove { _, _ in }
        }
        .listStyle(.plain)
    }
}
