//
//  SelectionView.swift
//  MonoList
//
//  Created by 竹田悠真 on 2022/02/26.
//

import SwiftUI

struct SelectionView: View {
    @Environment(\.dismiss) private var dismiss
    var title: LocalizedStringKey
    @Binding var selectedItem: String
    var allItems: [(name: String, image: String?)]
    
    init(title: LocalizedStringKey, selectedItem: Binding<String>, allItems: [(name: String, image: String)]) {
        self.title = title
        self._selectedItem = selectedItem
        self.allItems = allItems
    }
    
    init(title: LocalizedStringKey, selectedItem: Binding<String>, allItems: [String]) {
        self.title = title
        self._selectedItem = selectedItem
        self.allItems = allItems.map { ($0, nil) }
    }
    
    var body: some View {
        List {
            ForEach(allItems, id: \.name) { item in
                let isSelected = (selectedItem == item.name)
                Button {
                    withAnimation(.easeOut(duration: 0.2)) {
                        if !isSelected {
                            selectedItem = item.name
                        }
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        dismiss()
                    }
                } label: {
                    HStack {
                        if let image = item.image {
                            Label {
                                Text(item.name.localized)
                                    .foregroundColor(.primary)
                            } icon: {
                                Image(systemName: image)
                            }
                        } else {
                            Text(item.name.localized)
                                .foregroundColor(.primary)
                        }
                        Spacer()
                        Image(systemName: "checkmark")
                            .font(.subheadline.bold())
                            .opacity(isSelected ? 1 : 0)
                            .animation(.easeOut(duration: 0.2), value: isSelected)
                    } //: HStack
                } //: Button
            } //: ForEach
        } //: List
        .navigationTitle(Text(title))
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct SelectionView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SelectionView(title: "Secection", selectedItem: .constant("item2"), allItems: [("item1", "circle"), ("item2", "triangle"), ("item3", "square")])
        }
    }
}
