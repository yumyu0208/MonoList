//
//  PhotoCaptureView.swift
//  MonoList
//
//  Created by 竹田悠真 on 2022/02/25.
//

import SwiftUI

struct PhotoCaptureView: View {
    
    @Binding var showImagePicker: Bool
    @Binding var data: Data?
    var sourceType: UIImagePickerController.SourceType
    
    var body: some View {
        MLImagePicker(isShown: $showImagePicker, data: $data, sourceType: sourceType)
            .ignoresSafeArea()
    }
}

