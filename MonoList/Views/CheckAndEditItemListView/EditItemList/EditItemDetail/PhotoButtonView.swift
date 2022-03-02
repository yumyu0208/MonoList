//
//  PhotoView.swift
//  MonoList
//
//  Created by 竹田悠真 on 2022/02/16.
//

import SwiftUI

struct PhotoButtonView: View {
    
    @Environment(\.deeplink) var deeplink
    @Binding var imageData: Data?
    @State var isShowingImagePicker = false
    @State var isShowingCamera = false
    @State var isShowingDeleteConfirmationDialog: Bool = false
    
    var hasImage: Bool {
        imageData != nil
    }
    
    var body: some View {
        Menu {
            Button {
                isShowingImagePicker = true
            } label: {
                Label("Choose Photo", systemImage: "photo.on.rectangle")
            }
            Button {
                isShowingCamera = true
            } label: {
                Label("Take Photo", systemImage: "camera")
            }
            if hasImage {
                Button(role: .destructive) {
                    isShowingDeleteConfirmationDialog = true
                } label: {
                    Label("Delete Photo", systemImage: "trash")
                }
            }
        } label: {
            ZStack {
                Rectangle()
                    .foregroundStyle(Color(UIColor.systemGray6))
                if let imageData = imageData, let image = UIImage(data: imageData) {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                }
            }
            .frame(width: 64, height: 64)
            .overlay(alignment: .center) {
                Circle()
                    .frame(width: 32, height: 32)
                    .foregroundColor(Color(white: 0.95))
                    .shadow(color: Color(K.colors.ui.shadowColor7),
                            radius: 6)
                    .overlay(alignment: .center) {
                        Image(systemName: "camera.fill")
                            .font(.system(size: 12 ,design: .rounded))
                            .foregroundColor(Color(white: 0.4))
                    }
                    .opacity(hasImage ? 0 : 1)
            }
            .clipShape(RoundedRectangle(cornerRadius: 4, style: .continuous))
            .shadow(color: Color(K.colors.ui.shadowColor9), radius: 2, y: 2)
        } //: Menu
        .confirmationDialog("Photo.Delete.confirmation", isPresented: $isShowingDeleteConfirmationDialog) {
            Button(role: .destructive) {
                withAnimation(.easeOut(duration: 0.2)) {
                    imageData = nil
                }
                isShowingDeleteConfirmationDialog = false
            } label: {
                Text("Delete Photo")
            }
            Button("Cancel", role: .cancel) {
                isShowingDeleteConfirmationDialog = false
            }
        } message: {
            Text("Photo.Delete.confirmation")
        }
        .sheet(isPresented: $isShowingImagePicker) {
            PhotoCaptureView(showImagePicker: $isShowingImagePicker, data: $imageData, sourceType: .photoLibrary)
        }
        .fullScreenCover(isPresented: $isShowingCamera) {
            PhotoCaptureView(showImagePicker: $isShowingCamera, data: $imageData, sourceType: .camera)
        }
        .onChange(of: deeplink) { deeplink in
            if deeplink != nil {
                isShowingImagePicker = false
                isShowingCamera = false
                isShowingDeleteConfirmationDialog = false
            }
        }
    }
}

struct PhotoView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            PhotoButtonView(imageData: .constant(UIImage(contentsOfFile: "SampleImage")!.pngData()))
                .padding()
            .previewLayout(.sizeThatFits)
            PhotoButtonView(imageData: .constant(UIImage(contentsOfFile: "SampleImage")!.pngData()))
                .preferredColorScheme(.dark)
                .padding()
                .previewLayout(.sizeThatFits)
        }
    }
}
