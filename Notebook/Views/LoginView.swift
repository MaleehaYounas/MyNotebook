import SwiftUI

struct LoginView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @EnvironmentObject var notesVM: NotesViewModel
    @State private var email = ""
    @State private var password = ""
    @State private var showSignup = false
    @State private var navigateToContent = false
    var body: some View {
        NavigationStack {
            VStack {
                loginText
                if let error = viewModel.loginErrorMessage {
                    errorText(error: error)
                }
                emailTextField
                passwordTextField
                loginButton
                Button("Don't have an account? Sign Up") {
                    showSignup = true
                }
                .padding()
                .sheet(isPresented: $showSignup) {
                    SignupView().environmentObject(viewModel)
                }
                
            }
            .navigationDestination(isPresented: $navigateToContent) {
                NotesListView()
                    .environmentObject(viewModel)
                    .environmentObject(notesVM)
                    .navigationBarBackButtonHidden()
            }
        }
    }
    private var loginText:some View{
        Text("Login")
            .font(.largeTitle)
            .padding(.bottom, 30)
    }
    private var emailTextField:some View{
        TextField("Email", text: $email)
            .autocapitalization(.none)
            .keyboardType(.emailAddress)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding(.horizontal)
        
    }
    private var passwordTextField:some View{
        SecureField("Password", text: $password)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding(.horizontal)
        
    }
    private func errorText(error:String) -> some View{
        Text(error)
            .foregroundColor(.red)
            .multilineTextAlignment(.center)
            .padding(.horizontal)
    }
    private var loginButton:some View{
        Button(action: {
            viewModel.signIn(email: email, password: password) { success in
                if success {
                    navigateToContent = true
                } else {
                    print("Login failed")
                }
            }
        }) {
            Text("Login")
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                .padding(.horizontal)
        }
    }
}
