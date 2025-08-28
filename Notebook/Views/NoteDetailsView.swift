import SwiftUI

struct NoteDetailView: View {
    let note: Note
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                
                // Note date + content
                noteDetails(note: note)
                
                // Show images if available
                if let imageDataArray = note.imageData {
                    ForEach(imageDataArray, id: \.self) { base64String in
                        if let data = Data(base64Encoded: base64String),
                           let uiImage = UIImage(data: data) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFit()
                                .frame(maxHeight: 250)
                                .cornerRadius(10)
                                .padding(.vertical, 4)
                        }
                    }
                }
                
            }
            .padding(.horizontal)
        }
        .navigationTitle(note.title)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func noteDetails(note: Note) -> some View {
        Group {
            noteDate(date: note.date)
            noteContent(content: note.content)
        }
    }
    
    private func noteDate(date: Date) -> some View {
        Text(customDateFormatter.string(from: note.date))
            .font(.subheadline)
            .foregroundColor(.gray)
            .frame(maxWidth: .infinity, alignment: .center)
    }
    
    private func noteContent(content: String) -> some View {
        Text(content)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}
