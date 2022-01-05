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
    
    var body: some View {
        let isEditing = (editMode?.wrappedValue == .active)
        Button {
            withAnimation {
                editMode?.wrappedValue = isEditing ? .inactive : .active
            }
        } label: {
            HStack(spacing: 4.0) {
                Image(systemName: "slider.horizontal.3")
                    .foregroundColor(isEditing ? .white : .accentColor)
                Text("Edit")
                    .foregroundColor(.white)
                    .colorMultiply(sortButtonColor)
                    .onChange(of: isEditing) { isEditing in
                        withAnimation(.easeOut(duration: 0.2)) {
                            sortButtonColor = isEditing ? .white : .accentColor
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
