import Foundation
import SwiftUI
//UIViewControllerRepresentable lets us use UIKit inside SwiftUI.
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    @Environment(\.dismiss) private var dismiss
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
       // UIImagePickerController is Apple’s photo picker.
        let picker = UIImagePickerController()
        //we need a helper (Coordinator) to handle what happens when a user picks an image.
        picker.delegate = context.coordinator
        return picker
    }
    //Required function but not needed
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    
    //The coordinator will "listen" when the user picks an image.
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    //This helps to connect the UIKit image picker with our SwiftUI.
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        //Picker is parent
        let parent: ImagePicker
        init(_ parent: ImagePicker) { self.parent = parent }
        //This function runs when the user selects an image.
        func imagePickerController(_ picker: UIImagePickerController,
                                   didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
           // info[.originalImage] gets the chosen image.
            if let image = info[.originalImage] as? UIImage {
                parent.selectedImage = image
            }
            parent.dismiss()
        }
    }
}
