import SwiftUI
import FirebaseCore
@main
struct NotebookApp: App {
    /*For authenticaton enable email and password under build dropdown on left panel in firebase console*/
    @StateObject var viewModel = AuthViewModel()
    @StateObject var notesVM = NotesViewModel()

      init() {
          FirebaseApp.configure()
      }
      
      var body: some Scene {
          WindowGroup {
              if(viewModel.isSignedIn)
              {
                  NotesListView()
                      .environmentObject(viewModel)
                      .environmentObject(notesVM)
              }
              else{
                  LoginView()
                      .environmentObject(viewModel)
                      .environmentObject(notesVM)
              }
          }
      }
}
