//
//  CategoryLabelView.swift
//  MonoList
//
//  Created by 竹田悠真 on 2022/02/10.
//

import SwiftUI

struct CategoryLabelView: View {
    var category: Category
    
    var body: some View {
        HStack(spacing: 2) {
            Image(systemName: category.image ?? "tag")
            Text(category.name)
        }
        .font(.caption)
        .foregroundColor(.primary)
        .padding(.vertical, 4)
        .padding(.horizontal, 8)
        .background(Color(UIColor.systemGray5))
        .clipShape(Capsule())
    }
}

struct CategoryLabelView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        let category = CategoryManager.createNewCategory(name: "Category", image: "tag", order: 0, context)
        CategoryLabelView(category: category)
            .padding()
            .previewLayout(.sizeThatFits)
            .environment(\.managedObjectContext, context)
    }
}
