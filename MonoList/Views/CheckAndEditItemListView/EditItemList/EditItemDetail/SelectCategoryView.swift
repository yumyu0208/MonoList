//
//  SelectCategoryView.swift
//  MonoList
//
//  Created by 竹田悠真 on 2022/01/14.
//

import SwiftUI

struct SelectCategoryView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: [SortDescriptor(\.order, order: .forward)], animation: .default)
    private var categories: FetchedResults<Category>
    
    @Binding var selectedCategory: Category?
    
    @State var isEditingNewCategory = false
    @State var newCategory: Category?
    
    var body: some View {
        ZStack {
            List {
                Section {
                    let selectedCategoryIsNone = (selectedCategory == nil)
                    Button {
                        withAnimation(.easeOut(duration: 0.2)) {
                            if !selectedCategoryIsNone {
                                selectedCategory = nil
                            }
                            dismiss()
                        }
                    } label: {
                        HStack {
                            Text("None")
                                .foregroundColor(.primary)
                            Spacer()
                            Image(systemName: "checkmark")
                                .font(.body.bold())
                                .foregroundColor(.accentColor)
                                .imageScale(.medium)
                                .opacity(selectedCategoryIsNone ? 1 : 0)
                        } //: HStack
                    } //: Button
                } //: Section
                ForEach(categories, id: \.self) { category in
                    let isSelected = (selectedCategory?.name == category.name)
                    Button {
                        withAnimation(.easeOut(duration: 0.2)) {
                            if !isSelected {
                                selectedCategory = category
                            }
                            dismiss()
                        }
                    } label: {
                        HStack {
                            Label {
                                Text(category.name == K.defaultName.newCategory ? "New Category" : category.name)
                                    .foregroundColor(.primary)
                            } icon: {
                                Image(systemName: category.image ?? "tag")
                                    .foregroundStyle(.tint)
                            }
                            Spacer()
                            Image(systemName: "checkmark")
                                .font(.body.bold())
                                .foregroundColor(.accentColor)
                                .imageScale(.medium)
                                .opacity(isSelected ? 1 : 0)
                        } //: HStack
                    } //: Button
                } //: ForEach
                Button(action: {
                    withAnimation {
                        newCategory = addCategory(order: categories.count)
                        isEditingNewCategory = true
                        saveData()
                    }
                }) {
                    Label("Add Category", systemImage: "plus.app")
                        .foregroundStyle(.tint)
                }
            } //: List
            NavigationLink(isActive: $isEditingNewCategory) {
                if let editingCategory = newCategory {
                    EditCategoryView(category: editingCategory) { newCategory in
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            selectedCategory = newCategory
                            dismiss()
                        }
                    }
                    .navigationTitle(Text("New Category"))
                } else {
                    EmptyView()
                }
            } label: {
                EmptyView()
            }
        } //: ZStack
        .navigationTitle("Select Category")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func saveData() {
        do {
            try viewContext.save()
            print("Saved")
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    @discardableResult
    private func addCategory(name: String = K.defaultName.newCategory, image: String = "tag", order: Int) -> Category {
        let newCategory = CategoryManager.createNewCategory(name: name, image: image, order: order, viewContext)
        return newCategory
    }
}

