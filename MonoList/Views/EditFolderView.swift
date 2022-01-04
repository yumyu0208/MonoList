//
//  EditFolderView.swift
//  MonoList
//
//  Created by 竹田悠真 on 2021/12/31.
//

import SwiftUI

struct EditFolderView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) var dismiss
    
    @State var image: String = "folder"
    @State var name: String = ""
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
        } //: VStack
        .padding(.horizontal)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button {
                    folder.image = image
                    folder.name = name
                    dismiss()
                } label: {
                    Image(systemName: "checkmark")
                }
                .buttonStyle(CircleButton())
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
            } else {
                name = folder.name
            }
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
