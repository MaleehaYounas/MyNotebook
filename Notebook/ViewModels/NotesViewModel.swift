import FirebaseFirestore

class NotesViewModel: ObservableObject {
    private var db = Firestore.firestore()
    @Published var notes = [Note]()
    @Published var errorMessage:String = ""
    private var listener: ListenerRegistration?

    func addNote(title: String, content: String, date: Date, userId: String, images: [UIImage] = []) {
        var encodedImages: [String] = []
        for image in images {
            if let imageData = image.jpegData(compressionQuality: 0.2) {
                let base64 = imageData.base64EncodedString()
                encodedImages.append(base64)
            }
        }
        let newNote = Note(
            title: title,
            content: content,
            date: date,
            userId: userId,
            imageData: encodedImages.isEmpty ? nil : encodedImages
        )
        do {
            _ = try db.collection("notes").addDocument(from: newNote)
        } catch {
            self.errorMessage = "Error adding document: " + error.localizedDescription
        }
    }
    // Delete Note
    func deleteNote(note: Note) {
        guard let noteID = note.id else { return }

        db.collection("notes").document(noteID).delete { error in
            if let error = error {
                self.errorMessage = "Error deleting note: " + error.localizedDescription
            }
        }
    }
    func getNotes(for userId: String) {
          listener?.remove()

          listener = db.collection("notes")
            .whereField("userId", isEqualTo: userId)
            .order(by: "date", descending: true)
              .addSnapshotListener { snapshot, error in
                  if let error = error {
                      self.errorMessage = "Error getting notes: " + error.localizedDescription
                      return
                  }

                  self.notes = snapshot?.documents.compactMap { document in
                      try? document.data(as: Note.self)
                  } ?? []
              }
      }

    func updateNote(note: Note) {
        guard let noteID = note.id else { return }
        do {
            try db.collection("notes").document(noteID).setData(from: note, merge: true)
        } catch {
            self.errorMessage = "Error updating note: \(error.localizedDescription)"
        }
    }


}
