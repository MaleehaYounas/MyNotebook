import SwiftUI
import FirebaseAuth

struct NotesListView: View {
    @EnvironmentObject var notesVM: NotesViewModel
    @EnvironmentObject var authViewModel: AuthViewModel
    
    @State private var path: [NavigationDestination] = []
    @State private var isShowingConfirmationDialog: Bool = false
    @State private var noteToDelete: Note? = nil
    @State private var selectedNoteForEdit: Note? = nil
    
    var body: some View {
        NavigationStack(path: $path) {
                List {
                    ForEach(notesVM.notes) { note in
                        NavigationLink(value: NavigationDestination.detail(note)) {
                            ListItemLabel(note: note)
                        }
                        .swipeActions {
                            editButton(note: note)
                            deleteButton(note: note)
                        }
                    }
                }
                .navigationTitle("Notes")
                .navigationBarItems(
                    leading:
                        Menu {
                            logoutButton
                            deleteAccountButton
                        } label: {
                            accountMenuButton
                        },
                    trailing:
                        Button {
                            path.append(.addNote)
                        } label: {
                            Image(systemName: "plus")
                        }
                    
                
            )
            .onAppear {
                if let userId = authViewModel.user?.uid {
                    notesVM.getNotes(for: userId)
                }
            }
            .navigationDestination(for: NavigationDestination.self) { destination in
                switch destination {
                case .addNote:
                    if let userId = authViewModel.user?.uid {
                        AddNoteView(userId: userId)
                            .environmentObject(notesVM)
                    }
                case .editNote(let note):
                    if let userId = authViewModel.user?.uid {
                        EditNoteView(note: note, userId: userId)
                            .environmentObject(notesVM)
                    }
                case .detail(let note):
                    NoteDetailView(note: note)
                case .login:
                    LoginView()
                        .environmentObject(authViewModel)
                        .navigationBarBackButtonHidden()
                }
            }
            .confirmationDialog(
                "Are you sure you want to delete this note?",
                isPresented: $isShowingConfirmationDialog,
                titleVisibility: .visible
            ) {
                Button("Confirm", role: .destructive) {
                    if let note = noteToDelete {
                        notesVM.deleteNote(note: note)
                    }
                    if let userId = authViewModel.user?.uid {
                        notesVM.getNotes(for: userId)
                    }
                    noteToDelete = nil
                }
                Button("Cancel", role: .cancel) {
                    noteToDelete = nil
                }
            }
        }
    }
    
    private func ListItemLabel(note: Note) -> some View {
        VStack(alignment: .leading) {
            Text(note.title).font(.headline)
            Text(customDateFormatter.string(from: note.date)).font(.caption)
        }
    }
    
    private func editButton(note: Note) -> some View {
        Button("Edit") {
            path.append(.editNote(note))
        }
        .tint(.blue)
    }
    
    private func deleteButton(note: Note) -> some View {
        Button(role: .destructive) {
            noteToDelete = note
            isShowingConfirmationDialog = true
        } label: {
            Image(systemName: "trash")
        }
        .tint(.red)
    }
    
    private var logoutButton: some View {
        Button("Log Out") {
            authViewModel.signOut()
            path = [.login]
        }
    }
    
    private var deleteAccountButton: some View {
        Button(role: .destructive) {
            authViewModel.deleteAccount { success in
                if success {
                    path = [.login]
                }
            }
        } label: {
            Text("Delete Account")
        }
    }
    
    private var accountMenuButton: some View {
        VStack(spacing: 2) {
            Image(systemName: "person.circle")
                .resizable()
                .frame(width: 24, height: 24)
            Text("Account").font(.caption)
        }
    }
}
