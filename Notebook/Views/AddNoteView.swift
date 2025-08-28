import SwiftUI
struct AddNoteView: View {
    @EnvironmentObject var NotesVM: NotesViewModel
    @State private var title = ""
    @State private var content = ""
    @State private var selectedImages: [UIImage] = []
    @State private var showImagePicker = false
    
    let userId: String
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        Form {
            Section(header: Text("Note Details")) {
                TextField("Title", text: $title)
                contentTextBox
            }
            Section(header: Text("Images")) {
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(Array(selectedImages.enumerated()), id: \.element) { index, image in
                            ZStack(alignment: .topTrailing) {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 80, height: 80)
                                    .clipped()
                                    .cornerRadius(8)
                                
                                Button(action: {
                                    selectedImages.remove(at: index)
                                }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(.red)
                                        .background(Color.white.clipShape(Circle()))
                                }
                                .offset(x: 0, y: 0)
                            }
                        }
                        
                        Button(action: { showImagePicker = true }) {
                            Image(systemName: "plus")
                                .frame(width: 80, height: 80)
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(8)
                        }
                    }
                }
            }

            saveButton
        }
        .navigationTitle("Add")
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(selectedImage: Binding(
                get: { nil },
                set: { image in
                    if let image = image {
                        selectedImages.append(image)
                    }
                }
            ))
        }
    }
    
    private var contentTextBox: some View {
        ZStack(alignment: .topLeading) {
            if content.isEmpty {
                Text("Description")
                    .foregroundColor(.gray)
                    .opacity(0.6)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 12)
            }
            
            TextEditor(text: $content)
                .frame(minHeight: 120)
                .padding(4)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray.opacity(0.3))
                )
        }
    }
    
    private var saveButton: some View {
        Button(action: {
            if title.isEmpty {
                title = "Untitled Note"
            }
            
            NotesVM.addNote(
                title: title,
                content: content,
                date: Date.now,
                userId: userId,
                images: selectedImages
            )
            dismiss()
        }) {
            Text("Save")
                .frame(maxWidth: .infinity)
                .padding()
                .foregroundColor(.white)
                .background(Color.green)
                .cornerRadius(10)
        }
        .listRowBackground(Color.clear)
        .frame(maxWidth: .infinity, alignment: .center)
    }
}
