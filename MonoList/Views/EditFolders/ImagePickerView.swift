//
//  ImagePickerView.swift
//  MonoList
//
//  Created by 竹田悠真 on 2022/01/27.
//

import SwiftUI

struct ImagePickerView: View {
    
    
    private let images: [String: [String]]? = ImageManager.loadImageNames()
    
    @Binding var selectedImage: String
    @Binding var rows: [GridItem]
    
    var body: some View {
        if let images = images {
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHGrid(rows: rows,
                          spacing: 16) {
                    ForEach(K.key.folderImages, id: \.self) { key in
                        Section {
                            ForEach(images[key]!, id: \.self) { image in
                                let selected = (selectedImage == image)
                                ZStack {
                                    Image(systemName: "square")
                                        .padding(8)
                                        .foregroundColor(.clear)
                                    Image(systemName: image)
                                }
                                .font(.system(.title, design: .rounded))
                                .background(selected ? Color(UIColor.systemGray5) : .clear)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                .onTapGesture {
                                    if !selected {
                                        self.selectedImage = image
                                    }
                                }
                            } //: ForEach
                        } //: Section
                    } //: ForEach
                } //: LazyHGrid
                .padding()
                .padding(.horizontal, 8)
            } //: Scroll
        }
    }
}

struct ImagePickerView_Previews: PreviewProvider {
    
    @State static private var rows: [GridItem] = Array(repeating: .init(.flexible(minimum: 60, maximum: 200), spacing: 16), count: 3)
    
    static var previews: some View {
        ImagePickerView(selectedImage: .constant("star"), rows: $rows)
            .previewLayout(.fixed(width: 360, height: 300))
    }
}
