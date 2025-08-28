import SwiftUI
import FirebaseAuth

class AuthViewModel: ObservableObject {
    @Published var user: User? = nil
    @Published var isSignedIn: Bool = false
    @Published var loginErrorMessage:String? = ""
    @Published var signupErrorMessage: String? = nil
    @Published var errorMessage: String? = nil
    init() {
        self.user = Auth.auth().currentUser
        self.isSignedIn = user != nil
    }
    
    func signUp(email: String, password: String, completion: @escaping (Bool) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                self.signupErrorMessage = error.localizedDescription
                completion(false)
                return
            }
            self.user = result?.user
            self.isSignedIn = true
            completion(true)
        }
    }
    
    func signIn(email: String, password: String, completion: @escaping (Bool) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                self.loginErrorMessage = error.localizedDescription
                completion(false)
                return
            }
            self.user = result?.user
            self.isSignedIn = true
            completion(true)
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            self.user = nil
            self.isSignedIn = false
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
       
       func deleteAccount(completion: @escaping (Bool) -> Void) {
           guard let user = Auth.auth().currentUser else {
               self.errorMessage = "No user logged in."
               completion(false)
               return
           }
           
           user.delete { error in
               if let error = error {
                   self.errorMessage = error.localizedDescription
                   completion(false)
                   return
               }
               self.user = nil
               self.isSignedIn = false
               completion(true)
           }
       }

}
