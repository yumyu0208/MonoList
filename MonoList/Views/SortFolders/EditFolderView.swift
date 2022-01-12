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
    
    @State var image: String = "folder"
    @State var name: String = ""
    @FocusState var folderNameTextFieldIsFocused: Bool
    @ObservedObject var folder: Folder
    
    var body: some View {
        VStack(alignment: .center, spacing: 40) {
            Image(systemName: image)
                .font(.system(size: 60, weight: .semibold, design: .rounded))
                .foregroundColor(.accentColor)
            TextField("Folder Name", text: $name, prompt: Text("Folder Name"))
                .multilineTextAlignment(.center)
                .submitLabel(.done)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .focused($folderNameTextFieldIsFocused)
        } //: VStack
        .padding(.horizontal)
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button {
                    folder.image = image
                    folder.name = name
                    dismiss()
                } label: {
                    Image(systemName: "checkmark")
                }
                .buttonStyle(CircleButtonStyle())
                .disabled(name == "")
            }
            ToolbarItem(placement: .cancellationAction) {
                Button {
                    dismiss()
                } label: {
                    Text("Cancel")
                }
            }
        }
        .onAppear {
            image = folder.image
            if folder.name == K.defaultName.newFolder {
                name = ""
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    folderNameTextFieldIsFocused = true
                }
            } else {
                name = folder.name
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
