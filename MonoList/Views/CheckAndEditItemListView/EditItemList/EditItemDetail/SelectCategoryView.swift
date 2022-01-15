//
//  SelectCategoryView.swift
//  MonoList
//
//  Created by 竹田悠真 on 2022/01/14.
//

import SwiftUI

struct SelectCategoryView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var categories: [String] = ["Essentials", "Clothing", "Medicine", "Electronics", "Extras"]
    @Binding var selectedCategory: String?
    
    var body: some View {
        List {
            Section {
                let noneIsSelected = (selectedCategory == "None")
                Button {
                    withAnimation(.easeOut(duration: 0.2)) {
                        if !noneIsSelected {
                            selectedCategory = nil
                        }
                        dismiss()
                    }
                } label: {
                    HStack {
                        Text("None")
                            .foregroundColor(.primary)
                        Spacer()
                        Image(systemName: "checkmark")
                            .font(.body.bold())
                            .foregroundColor(.accentColor)
                            .imageScale(.medium)
                            .opacity(noneIsSelected ? 1 : 0)
                    } //: HStack
                } //: Button
            } //: Section
            ForEach(categories, id: \.self) { category in
                let isSelected = (selectedCategory == category)
                Button {
                    withAnimation(.easeOut(duration: 0.2)) {
                        if !isSelected {
                            selectedCategory = category
                        }
                        dismiss()
                    }
                } label: {
                    HStack {
                        Text(category)
                            .foregroundColor(.primary)
                        Spacer()
                        Image(systemName: "checkmark")
                            .font(.body.bold())
                            .foregroundColor(.accentColor)
                            .imageScale(.medium)
                            .opacity(isSelected ? 1 : 0)
                    } //: HStack
                } //: Button
            } //: ForEach
        } //: List
        .navigationTitle("Select Category")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct SelectCategoryView_Previews: PreviewProvider {
    @State static var selectedCategory: String? = "Clothing"
    static var previews: some View {
        NavigationView {
            SelectCategoryView(selectedCategory: $selectedCategory)
        }
    }
}
