//
//  ListTitleView.swift
//  MonoList
//
//  Created by 竹田悠真 on 2022/01/11.
//

import SwiftUI

struct ListTitleView: View {
    
    @Environment(\.editMode) var editMode
    
    @ObservedObject var itemList: ItemList
    var submitAction: (() -> Void)?
    
    var icon: ListIcon {
        ListIcon(name: itemList.iconName, image: itemList.image, color: itemList.color, primaryColor: itemList.primaryColor, secondaryColor: itemList.secondaryColor, tertiaryColor: itemList.tertiaryColor)
    }
    
    var body: some View {
        Label {
            TextField("List Name", text: $itemList.name, prompt: Text("List Name"))
                .submitLabel(.done)
                .disabled(!(editMode?.wrappedValue.isEditing ?? false))
                .onSubmit {
                    if let submitAction = submitAction {
                        submitAction()
                    }
                }
        } icon: {
            IconImageView(icon: icon)
        }
        .font(.title.bold())
        .padding(.vertical)
    }
}

struct ListTitleView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        let itemList = MonoListManager().fetchItemLists(context: context)[0]
        ListTitleView(itemList: itemList)
            .environment(\.managedObjectContext, context)
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
