//
//  EditFolderView.swift
//  MonoList
//
//  Created by 竹田悠真 on 2021/12/31.
//

import SwiftUI

struct EditFolderView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    
    @State var selectedImage: String = "folder"
    @State var selectedName: String = ""
    @FocusState var folderNameTextFieldIsFocused: Bool
    @ObservedObject var folder: Folder
    
    @State private var rows: [GridItem] = Array(repeating: .init(.flexible(minimum: 60, maximum: 200), spacing: 16), count: 3)
    
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
                .focused($folderNameTextFieldIsFocused)
                .padding(.horizontal)
            ImagePickerView(selectedImage: $selectedImage, rows: $rows)
            Button {
                folder.image = selectedImage
                folder.name = selectedName
                saveData()
                dismiss()
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
                    dismiss()
                } label: {
                    Text("Cancel")
                }
            }
        }
        .onChange(of: folderNameTextFieldIsFocused) { focused in
            rows = Array(repeating: .init(.flexible(minimum: 60, maximum: 200), spacing: 16), count: focused ? 1 : 3)
        }
        .onAppear {
            selectedImage = folder.image
            if folder.name == K.defaultName.newFolder {
                selectedName = ""
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    folderNameTextFieldIsFocused = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        if folderNameTextFieldIsFocused == false {
                            folderNameTextFieldIsFocused = true
                        }
                    }
                }
            } else {
                selectedName = folder.name
            }
        }
        .onDisappear {
            if folder.name == K.defaultName.newFolder {
                withAnimation {
                    viewContext.delete(folder)
                    saveData()
                }
            }
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
}

struct EditFolderView_Previews: PreviewProvider {
    static let folders = MonoListManager().createSamples(context: PersistenceController.preview.container.viewContext)
    static var previews: some View {
        NavigationView {
            EditFolderView(folder: folders[0])
        }
    }
}