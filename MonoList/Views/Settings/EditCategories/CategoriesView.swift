//
//  CategoriesView.swift
//  MonoList
//
//  Created by 竹田悠真 on 2022/02/09.
//

import SwiftUI

struct CategoriesView: View {
    @AppStorage(K.key.isPlusPlan) private var isPlusPlan: Bool = false
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: [SortDescriptor(\.order, order: .forward)], animation: .default)
    private var categories: FetchedResults<Category>
    
    @State var editMode: EditMode = .inactive
    @State var isEditingNewCategory = false
    @State var newCategory: Category?
    
    @State var isShowingDeleteConfirmationDialog: Bool = false
    @State var deleteIndexSet: IndexSet?
    
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
                            .id("\(category.name)\(category.image ?? "")")
                        } //: NavigationLink
                        .contextMenu {
                            Button(role: .destructive) {
                                if let index = categories.firstIndex(of: category) {
                                    deleteIndexSet = IndexSet(integer: index)
                                    isShowingDeleteConfirmationDialog = true
                                }
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                        .swipeActions(edge: .trailing) {
                            Button(role: .destructive) {
                                if let index = categories.firstIndex(of: category) {
                                    deleteIndexSet = IndexSet(integer: index)
                                    isShowingDeleteConfirmationDialog = true
                                }
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                        .inoperable(!isPlusPlan, padding: .defaultListInsets) {
                            NavigationView {
                                PlusPlanView(featureType: .category)
                            }
                        }
                    }
                    .onDelete { indexSet in
                        deleteIndexSet = indexSet
                        isShowingDeleteConfirmationDialog = true
                    }
                    .onMove(perform: moveCategory)
                    if editMode != .active {
                        HStack {
                            Button(action: {
                                withAnimation {
                                    newCategory = addCategory(order: categories.count)
                                    isEditingNewCategory = true
                                    saveData()
                                }
                            }) {
                                Label("Add Category", systemImage: "plus.app")
                                    .foregroundStyle(.tint)
                            } // Button
                            Spacer()
                        }
                        .inoperable(!isPlusPlan, padding: .defaultListInsets) {
                            NavigationView {
                                PlusPlanView(featureType: .category)
                            }
                        }
                    }
                } header: {
                    HStack(alignment: .center) {
                        Text("categories.description")
                            .textCase(nil)
                            .foregroundStyle(Color(UIColor.secondaryLabel))
                            .font(.footnote)
                        Spacer()
                        EditLabelView()
                            .imageScale(.medium)
                            .font(.subheadline.bold())
                            .environment(\.editMode, $editMode)
                            .textCase(nil)
                            .disabled(!isPlusPlan)
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
        .confirmationDialog("Are you sure you want to delete this category?", isPresented: $isShowingDeleteConfirmationDialog, titleVisibility: .visible, presenting: deleteIndexSet) { indexSet in
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
        .onAppear {
            CategoryManager().orderCategory(context: viewContext)
            saveData()
        }
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
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
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
