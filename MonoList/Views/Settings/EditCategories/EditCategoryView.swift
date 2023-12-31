//
//  EditCategoryView.swift
//  MonoList
//
//  Created by 竹田悠真 on 2022/02/09.
//

import SwiftUI

struct EditCategoryView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    
    @State var selectedImage: String = "tag"
    @State var selectedName: String = ""
    @FocusState var categoryNameTextFieldIsFocused: Bool
    @ObservedObject var category: Category
    @State var isShowingCancelConfirmationAlert: Bool = false
    
    @State private var rows: [GridItem] = Array(repeating: .init(.flexible(minimum: 60, maximum: 200), spacing: 16), count: 3)
    
    var completion: ((Category) -> Void)? = nil
    
    var isNew: Bool {
        category.name == K.defaultName.newCategory
    }
    
    var isEdited: Bool {
        selectedImage != category.image || selectedName != category.name
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer(minLength: 0)
            Image(systemName: selectedImage)
                .font(.system(size: 40,design: .rounded))
                .foregroundColor(.accentColor)
                .animation(.none, value: selectedImage)
            Spacer(minLength: 0)
            TextField("", text: $selectedName)
                .font(.title3)
                .multilineTextAlignment(.center)
                .submitLabel(.done)
                .textFieldStyle(.roundedGray)
                .focused($categoryNameTextFieldIsFocused)
                .padding(.horizontal)
            ImagePickerView(selectedImage: $selectedImage, type: .category, rows: $rows)
            Button {
                category.image = selectedImage
                category.name = selectedName
                saveData()
                dismiss()
                if let completion = completion {
                    completion(category)
                }
            } label: {
                Label("Done", systemImage: "checkmark")
            }
            .buttonStyle(.capsule)
            .padding(.horizontal)
            .disabled(selectedName.isEmpty)
        } //: VStack
        .padding(.vertical)
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button {
                    if isNew || isEdited {
                        categoryNameTextFieldIsFocused = false
                        isShowingCancelConfirmationAlert = true
                    } else {
                        dismiss()
                    }
                } label: {
                    Text("Cancel")
                }
            }
        }
        .alert("BackWithoutSave.description", isPresented: $isShowingCancelConfirmationAlert) {
            Button(role: .destructive) {
                dismiss()
            } label: {
                Text("Close Without Saving")
            }
            Button("Cancel", role: .cancel) {
                isShowingCancelConfirmationAlert = false
            }
        }
        .onChange(of: categoryNameTextFieldIsFocused) { focused in
            rows = Array(repeating: .init(.flexible(minimum: 60, maximum: 200), spacing: 16), count: focused ? 1 : 3)
        }
        .onAppear {
            selectedImage = category.image ?? "tag"
            if isNew {
                selectedName = ""
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    categoryNameTextFieldIsFocused = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        if categoryNameTextFieldIsFocused == false {
                            categoryNameTextFieldIsFocused = true
                        }
                    }
                }
            } else {
                selectedName = category.name
            }
        }
        .onDisappear {
            if isNew {
                withAnimation {
                    viewContext.delete(category)
                    // Crash when doing the following
                    //saveData()
                }
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
}

