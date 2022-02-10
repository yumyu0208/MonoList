//
//  SortButtonView.swift
//  MonoList
//
//  Created by 竹田悠真 on 2022/01/02.
//

import SwiftUI

struct EditLabelView: View {
    
    @Environment(\.editMode) var editMode
    @State var sortButtonColor: Color = .accentColor
    
    var imageOnly = false
    var action: (() -> Void)?
    
    var body: some View {
        let isEditing = (editMode?.wrappedValue == .active)
        Group {
            if imageOnly {
                Image(systemName: "arrow.up.arrow.down")
                    .foregroundColor(isEditing ? Color(K.colors.ui.buttonLabelColor) : .accentColor)
                    .padding(8)
                    .background(isEditing ? Color.accentColor : .clear)
                    .clipShape(Circle())
            } else {
                Label {
                    Text("Sort")
                        .foregroundColor(isEditing ? Color(K.colors.ui.buttonLabelColor) : .accentColor)
                        .colorMultiply(sortButtonColor)
                        .onChange(of: isEditing) { isEditing in
                            withAnimation(.easeOut(duration: 0.2)) {
                                sortButtonColor = isEditing ? Color(K.colors.ui.buttonLabelColor) : .accentColor
                            }
                        }
                } icon: {
                    Image(systemName: "arrow.up.arrow.down")
                        .foregroundColor(isEditing ? Color(K.colors.ui.buttonLabelColor) : .accentColor)
                }
                .padding(8)
                .background(isEditing ? Color.accentColor : .clear)
                .clipShape(Capsule())
            }
        }
        .animation(.easeOut(duration: 0.2), value: isEditing)
        .onTapGesture {
            withAnimation {
                if let action = action {
                    action()
                } else {
                    editMode?.wrappedValue = isEditing ? .inactive : .active
                }
            }
        }
    }
}

struct EditButtonView_Previews: PreviewProvider {
    static var previews: some View {
        EditLabelView()
            .padding()
            .previewLayout(.sizeThatFits)
        EditLabelView()
            .padding()
            .previewLayout(.sizeThatFits)
            .environment(\.editMode, .constant(.active))
    }
}
