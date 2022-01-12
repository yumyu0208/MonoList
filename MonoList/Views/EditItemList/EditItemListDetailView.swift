//
//  EditItemListDetailView.swift
//  MonoList
//
//  Created by 竹田悠真 on 2022/01/11.
//

import SwiftUI

struct EditItemListDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.managedObjectContext) private var viewContext
    @State private var editMode: EditMode = .active
    @ObservedObject var itemList: ItemList
    
    var body: some View {
        ScrollView {
            VStack {
                VStack(spacing: 20) {
                    NotificationsGroupBoxView(itemList: itemList)
                        .environment(\.editMode, $editMode)
                }
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                HStack {
                    Image(systemName: itemList.image)
                        .foregroundStyle(Color(itemList.color))
                    Text(itemList.name)
                }
                .font(.body.bold())
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                }
                .buttonStyle(CircleButtonStyle(type: .cancel))
            } // :ToolBarItem
        }
        .background(
            Color(UIColor.systemGroupedBackground)
                .ignoresSafeArea(.all, edges: .all)
        )
    }
    
    private func saveData() {
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}

struct EditItemListDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        let itemList = MonoListManager().fetchItemLists(context: context)[0]
        NavigationView {
            EditItemListDetailView(itemList: itemList)
                .environment(\.managedObjectContext, context)
        }
    }
}
