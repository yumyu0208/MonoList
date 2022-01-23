//
//  SortButtonView.swift
//  MonoList
//
//  Created by 竹田悠真 on 2022/01/02.
//

import SwiftUI

struct EditButtonView: View {
    
    @Environment(\.editMode) var editMode
    @State var sortButtonColor: Color = .accentColor
    
    var action: (() -> Void)?
    
    var body: some View {
        let isEditing = (editMode?.wrappedValue == .active)
        Button {
            withAnimation {
                if let action = action {
                    action()
                } else {
                    editMode?.wrappedValue = isEditing ? .inactive : .active
                }
            }
        } label: {
            HStack(spacing: 4.0) {
                Image(systemName: "arrow.up.arrow.down")
                    .foregroundColor(isEditing ? Color(K.colors.ui.buttonLabelColor) : .accentColor)
                Text("Sort")
                    .foregroundColor(isEditing ? Color(K.colors.ui.buttonLabelColor) : .accentColor)
                    .colorMultiply(sortButtonColor)
                    .onChange(of: isEditing) { isEditing in
                        withAnimation(.easeOut(duration: 0.2)) {
                            sortButtonColor = isEditing ? Color(K.colors.ui.buttonLabelColor) : .accentColor
                        }
                    }
            }
            .padding(8)
            .background(
                Capsule()
                    .fill(isEditing ? Color.accentColor : .clear)
            )
        }
        .animation(.easeOut(duration: 0.2), value: isEditing)
    }
}

struct EditButtonView_Previews: PreviewProvider {
    static var previews: some View {
        EditButtonView()
            .padding()
            .previewLayout(.sizeThatFits)
        EditButtonView()
            .padding()
            .previewLayout(.sizeThatFits)
            .environment(\.editMode, .constant(.active))
    }
}
