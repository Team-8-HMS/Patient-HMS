import SwiftUI
import FirebaseAuth

struct ForgotPasswordView: View {
    @State private var email: String = ""
    @State private var showAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var isMailSent = false
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationStack {
            ZStack {
                // Background image
                Image("LoginUi")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    Spacer()

                    // Header text
                    Text("Forgot your password?")
                        .font(.title)
                        .foregroundColor(.black)
                        .padding(.bottom, 30)
                    
                    // Email TextField
                    TextField("Email ID", text: $email)
                        .padding()
                        .frame(width: 120)
                        .background(Color.white.opacity(0.8))
                        .cornerRadius(20)
                        .padding(.horizontal, 40)
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)
                        .disableAutocorrection(true)
                        .foregroundColor(.black)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.black, lineWidth: 1)
                        )
                    
                    // Reset Password Button
                    Button(action: sendMail) {
                        Text("Reset")
                            .foregroundColor(.white)
                            .padding()
                            .frame(width: 100)
                            .background(Color(red: 230/255, green: 110/255, blue: 82/255))
                            .cornerRadius(15)
                            .padding(.top, 20)
                    }

                    Spacer()
                }
                .padding(.horizontal, 20)
            }
            .navigationBarTitle("")
        }
        .navigationBarBackButtonHidden(true)
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text(alertTitle),
                message: Text(alertMessage),
                dismissButton: .default(Text("OK"), action: {
                    if isMailSent {
                        presentationMode.wrappedValue.dismiss()
                    }
                })
            )
        }
    }

    func sendMail() {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                alertTitle = "Error"
                alertMessage = error.localizedDescription
                isMailSent = false
            } else {
                alertTitle = "Mail Sent"
                alertMessage = "A password reset email has been sent to \(email)."
                isMailSent = true
            }
            showAlert = true
        }
    }
}

struct ForgotPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ForgotPasswordView()
    }
}

