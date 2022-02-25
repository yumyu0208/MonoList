//
//  PhotoCaptureView.swift
//  MonoList
//
//  Created by 竹田悠真 on 2022/02/25.
//

import SwiftUI

struct MLImagePicker : UIViewControllerRepresentable {
    
    @Binding var isShown: Bool
    @Binding var data: Data?
    var sourceType: UIImagePickerController.SourceType
    
    class Cordinator : NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate{
        
        @Binding var isShown: Bool
        @Binding var data: Data?
        var sourceType: UIImagePickerController.SourceType
        
        init(isShown : Binding<Bool>, data: Binding<Data?>, sourceType: UIImagePickerController.SourceType) {
            _isShown = isShown
            _data = data
            self.sourceType = sourceType
        }
        
        //Selected Image
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            let image = info[UIImagePickerController.InfoKey.editedImage] as! UIImage
            let data = image.smallImage(minValue: 120).jpegData(compressionQuality: 0.8)
            self.data = data
            isShown = false
        }
        
        //Image selection got cancel
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            isShown = false
        }
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<MLImagePicker>) {
        
    }
    
    func makeCoordinator() -> Cordinator {
        return Cordinator(isShown: $isShown, data: $data, sourceType: sourceType)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<MLImagePicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = context.coordinator
        picker.allowsEditing = true
        return picker
    }
}
