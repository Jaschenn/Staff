//
//  ImagePickerView.swift
//  Staff-version0.1.0
//
//  Created by jas chen on 2020/3/20.
//  Copyright © 2020 jas chen. All rights reserved.
//

import SwiftUI


struct ImagePickerView: View {
    @Binding var showImagePicker    : Bool
    @Binding var uiImage              : UIImage?
    var body: some View{
        ImagePicker(isShown: $showImagePicker, uiImage: $uiImage)
    }
}


struct ImagePicker : UIViewControllerRepresentable {
    @Binding var isShown : Bool
    @Binding var uiImage : UIImage?
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {
    }
    func makeCoordinator() -> ImagePickerCordinator {
        return ImagePickerCordinator(isShown: $isShown, image: $uiImage)
    }
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }
}



// supporting class
class ImagePickerCordinator : NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    @Binding var isShown    : Bool
    @Binding var uiImage      : UIImage?
    
    init(isShown : Binding<Bool>, image: Binding<UIImage?>) {
        _isShown = isShown
        _uiImage   = image
    }
    
    //Selected Image
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let uiImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        self.uiImage = uiImage
        isShown = false
    }
    
    //Image selection got cancel
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        isShown = false
    }
}




//
//struct ImagePickerView_Previews: PreviewProvider {
//    static var previews: some View {
//        ImagePickerView(showImagePicker: .constant(false))
//    }
//}
