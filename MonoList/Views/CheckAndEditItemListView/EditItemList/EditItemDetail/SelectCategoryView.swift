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
    
    private let editCategoryTag: Int = 888
    @State var navigationLinkTag: Int?
    @State var editCategoryView: EditCategoryView?
    
    @State var isShowingDeleteConfirmationDialog: Bool = false
    @State var deleteIndexSet: IndexSet?
    
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
                            Label {
                                Text("None")
                                    .foregroundColor(.primary)
                            } icon: {
                                Image(systemName: "tag.slash")
                                    .foregroundColor(.accentColor)
                            }
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
                                    .foregroundColor(.accentColor)
                            }
                            .id("\(category.name)\(category.image ?? "")")
                            Spacer()
                            Image(systemName: "checkmark")
                                .font(.body.bold())
                                .foregroundColor(.accentColor)
                                .imageScale(.medium)
                                .opacity(isSelected ? 1 : 0)
                        } //: HStack
                    } //: Button
                    .swipeActions(edge: .trailing) {
                        Button(role: .destructive) {
                            if let index = categories.firstIndex(of: category) {
                                deleteIndexSet = IndexSet(integer: index)
                                isShowingDeleteConfirmationDialog = true
                            }
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                        .tint(.red)
                        Button {
                            editCategoryView = EditCategoryView(category: category)
                            navigationLinkTag = editCategoryTag
                        } label: {
                            Label("Edit", systemImage: "pencil")
                        }
                        .tint(.orange)
                    }
                } //: ForEach
                Button(action: {
                    withAnimation {
                        newCategory = addCategory(order: categories.count)
                        isEditingNewCategory = true
                    }
                }) {
                    Label("Add Category", systemImage: "plus.app")
                        .foregroundStyle(.tint)
                }
            } //: List
            NavigationLink(tag: editCategoryTag,
                           selection: $navigationLinkTag) {
                editCategoryView
            } label: {
                EmptyView()
            } //: NavigationLink
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
        .confirmationDialog("Category.Delete.confirmation", isPresented: $isShowingDeleteConfirmationDialog, titleVisibility: .visible, presenting: deleteIndexSet) { indexSet in
            Button(role: .destructive) {
                deleteCategories(offsets: indexSet)
            } label: {
                Text("Delete Category")
            }
            Button("Cancel", role: .cancel) {
                deleteIndexSet = nil
            }
        } message: { indexSet in
            if let index = indexSet.first {
                Text("The category of items in \(categories[index].name) will be \"None\"")
            }
        }
    }
    
    private func saveData() {
        do {
            try viewContext.save()
            #if DEBUG
            print("Saved")
            #endif
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    @discardableResult
    private func addCategory(name: String = K.defaultName.newCategory, image: String = "tag", order: Int) -> Category {
        let newCategory = CategoryManager.createNewCategory(name: name, image: image, order: order, viewContext)
        saveData()
        return newCategory
    }
    
    private func deleteCategories(offsets: IndexSet) {
        withAnimation {
            offsets.forEach { deleteIndex in
                Category.delete(index: deleteIndex, categories: categories, viewContext)
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            saveData()
        }
    }
}

