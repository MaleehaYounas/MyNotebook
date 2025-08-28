
import SwiftUI

struct EditNoteView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var NotesVM: NotesViewModel
    @State var note: Note
    @State private var title = ""
    @State private var content = ""
    @State private var selectedImages: [UIImage] = []
    @State private var showImagePicker = false
    let userId: String
    
    var body: some View {
        NavigationView {
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
                                    .offset(x: -5, y: 5)
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
            .navigationTitle(note.id == nil ? "Add Note" : "Edit Note")
            .navigationBarItems(trailing: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            })
            .onAppear {
                self.title = note.title
                self.content = note.content
                
                // Decoding Base64 to UIImage
                if let base64Strings = note.imageData {
                    self.selectedImages = base64Strings.compactMap { base64 in
                        if let data = Data(base64Encoded: base64),
                           let uiImage = UIImage(data: data) {
                            return uiImage
                        }
                        return nil
                    }
                }
            }
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
    }
    
    private var contentTextBox: some View {
        TextEditor(text: $content)
            .frame(minHeight: 120)
            .padding(4)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray.opacity(0.3))
            )
    }
    
    private var saveButton: some View {
        Button(action: {
            if title.isEmpty {
                title = "Untitled Note"
            }
            if let _ = note.id {
                var updatedNote = note
                updatedNote.title = title
                updatedNote.content = content
                updatedNote.date = Date()
                
                updatedNote.imageData = selectedImages.compactMap { image in
                    if let data = image.jpegData(compressionQuality: 0.2) {
                        return data.base64EncodedString()
                    }
                    return nil
                }
                
                NotesVM.updateNote(note: updatedNote)
            }
            else {
                NotesVM.addNote(
                    title: title,
                    content: content,
                    date: Date(),
                    userId: userId,
                    images: selectedImages
                )
            }
            presentationMode.wrappedValue.dismiss()
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
