//
//  EditItemListButtonView.swift
//  MonoList
//
//  Created by 竹田悠真 on 2022/02/12.
//

import SwiftUI

struct EditItemListButtonView: View {
    @Environment(\.isEnabled) private var isEnabled: Bool
    @Binding var isEditMode: Bool
    var action: () -> Void
    
    var labelColor: Color {
        if isEditMode {
            return Color(K.colors.ui.buttonLabelColor)
        } else {
            return isEnabled ? Color.accentColor : Color(UIColor.tertiaryLabel)
        }
    }
    
    var backgroundColor: Color {
        if isEditMode {
            return isEnabled ? Color.accentColor : Color(UIColor.tertiaryLabel)
        } else {
            return .clear
        }
    }
    
    var body: some View {
        Button {
            action()
            withAnimation(.easeOut(duration: 0.2)) {
                isEditMode.toggle()
            }
        } label: {
            Label("Edit", systemImage: "pencil")
                .foregroundColor(labelColor)
                .padding(4)
                .background(backgroundColor)
                .clipShape(Circle())
        } //: Button
    }
}

struct EditItemListButtonView_Previews: PreviewProvider {
    static var previews: some View {
        EditItemListButtonView(isEditMode: .constant(true)) {
            
        }
    }
}
