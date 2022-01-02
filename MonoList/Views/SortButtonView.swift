//
//  SortButtonView.swift
//  MonoList
//
//  Created by 竹田悠真 on 2022/01/02.
//

import SwiftUI

struct SortButtonView: View {
    
    @Environment(\.editMode) var editMode
    @State var sortButtonColor: Color = .accentColor
    
    var body: some View {
        let isEditing = editMode?.wrappedValue.isEditing ?? false
        Button {
            withAnimation {
                editMode?.wrappedValue = isEditing ? .inactive : .active
            }
        } label: {
            HStack(spacing: 4.0) {
                Image(systemName: "arrow.up.arrow.down")
                    .foregroundColor(isEditing ? .white : .accentColor)
                Text("Sort")
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

struct SortButtonView_Previews: PreviewProvider {
    static var previews: some View {
        SortButtonView()
            .padding()
            .previewLayout(.sizeThatFits)
        SortButtonView()
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
