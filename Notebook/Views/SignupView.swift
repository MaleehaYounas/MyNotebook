import SwiftUI

struct SignupView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @EnvironmentObject var notesVM: NotesViewModel
    @Environment(\.dismiss) var dismiss
    @State private var email = ""
    @State private var password = ""
    @State private var showSuccessAlert = false

    var body: some View {
        VStack {
            signUpText
            if let error = viewModel.signupErrorMessage {
                errorText(error:error)
            }
            emailTextField
            passwrordTextField
            signUpButton
            Button("Already have an account? Log In") {
              dismiss()
            }
            .padding()
        }.alert("Account Created Successfully", isPresented: $showSuccessAlert) {
            Button("OK") {
                dismiss()
            }
        } message: {
            Text("Login to your account to continue")
        }
    }
    private var signUpText:some View{
        Text("Sign Up")
            .font(.largeTitle)
            .padding(.bottom, 30)
    }
    
    private func errorText(error:String) -> some View{
        Text(error)
            .foregroundColor(.red)
            .multilineTextAlignment(.center)
    }
    
    private var emailTextField:some View{
        TextField("Email", text: $email)
            .autocapitalization(.none)
            .keyboardType(.emailAddress)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding(.horizontal)
    }
    private var passwrordTextField:some View{
        SecureField("Password", text: $password)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding(.horizontal)
    }
    
    private var signUpButton:some View{
        Button(action: {
            viewModel.signUp(email: email, password: password) { success in
                if success {
                    showSuccessAlert = true
                } else {
                    print("Signup failed")
                }
            }
        }) {
            Text("Sign Up")
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(10)
                .padding(.horizontal)
        }
    }
 
}
