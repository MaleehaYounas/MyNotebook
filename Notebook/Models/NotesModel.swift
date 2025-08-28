import FirebaseFirestore

struct Note: Identifiable, Codable, Hashable {
    @DocumentID var id: String?
    var title: String
    var content: String
    var date: Date
    var userId: String
    var imageData: [String]?
}

 let customDateFormatter: DateFormatter = {
       let formatter = DateFormatter()
       formatter.dateFormat = "MMMM d, yyyy 'at' h:mm a"
       return formatter
   }()

enum NavigationDestination: Hashable {
    case addNote
    case editNote(Note)
    case detail(Note)
    case login
    
}
