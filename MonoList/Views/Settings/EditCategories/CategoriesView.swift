//
//  CategoriesView.swift
//  MonoList
//
//  Created by 竹田悠真 on 2022/02/09.
//

import SwiftUI

struct CategoriesView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: [SortDescriptor(\.order, order: .forward)], animation: .default)
    private var categories: FetchedResults<Category>
    
    @State var editMode: EditMode = .inactive
    @State var isEditingNewCategory = false
    @State var newCategory: Category?
    
    var body: some View {
        ZStack {
            List {
                Section {
                    ForEach(categories) { category in
                        NavigationLink {
                            EditCategoryView(category: category)
                                .navigationTitle(Text("Edit Category"))
                        } label: {
                            Label {
                                Text(category.name == K.defaultName.newCategory ? "New Category" : category.name)
                            } icon: {
                                Image(systemName: category.image != nil ? category.image! : "tag")
                            }
                        }
                    }
                    .onDelete(perform: deleteCategories)
                    .onMove(perform: moveCategory)
                    if editMode != .active {
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
                    }
                } header: {
                    HStack(alignment: .center) {
                        Spacer()
                        EditButtonView()
                            .imageScale(.medium)
                            .font(.subheadline.bold())
                            .environment(\.editMode, $editMode)
                            .textCase(nil)
                    }
                } //: Section
            } //: List
            .listStyle(.insetGrouped)
            .environment(\.editMode, $editMode)
            NavigationLink(isActive: $isEditingNewCategory) {
                if let editingCategory = newCategory {
                    EditCategoryView(category: editingCategory)
                        .navigationTitle(Text("New Category"))
                }
            } label: {
                EmptyView()
            }
        } //: ZStack
        .navigationBarTitle(Text("Categories"))
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
    
    private func deleteCategories(offsets: IndexSet) {
        withAnimation {
            offsets.forEach { deleteIndex in
                Category.delete(index: deleteIndex, categories: categories, viewContext)
            }
            saveData()
        }
    }
    
    private func moveCategory(indexSet: IndexSet, destination: Int) {
        withAnimation {
            indexSet.forEach { source in
                if source < destination {
                    var startIndex = source + 1
                    let endIndex = destination - 1
                    var startOrder = categories[source].order
                    while startIndex <= endIndex {
                        categories[startIndex].order = startOrder
                        startOrder += 1
                        startIndex += 1
                    }
                    categories[source].order = startOrder
                } else if destination < source {
                    var startIndex = destination
                    let endIndex = source - 1
                    var startOrder = categories[destination].order + 1
                    let newOrder = categories[destination].order
                    while startIndex <= endIndex {
                        categories[startIndex].order = startOrder
                        startOrder += 1
                        startIndex += 1
                    }
                    categories[source].order = newOrder
                }
                saveData()
            }
        }
    }
}

struct CategoriesView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        NavigationView {
            CategoriesView()
                .environment(\.managedObjectContext, context)
        }
    }
}
