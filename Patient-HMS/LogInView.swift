//
//  ContentView.swift
//  SignupHMS
//
//  Created by Darshika Gupta on 04/07/24.
//

import SwiftUI
import FirebaseAuth


struct LogInView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isPasswordVisible = false // State to toggle password visibility
    @State private var createAccountButtonTapped = false
    @State private var isLoggedIn = false
    @State private var emailError: String?
    @State private var passwordError: String?
    @State private var loginError: String?

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Spacer()

                // Illustration
                Image("SignIn")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 211, height: 170)
                    .padding(.bottom, 70)

               

                // Email Field
                VStack(alignment: .leading, spacing: 5) {
                                   HStack {
                                       Image(systemName: "envelope")
                                           .foregroundColor(.gray)
                                       TextField("Email ID", text: $email)
                                           .autocapitalization(.none)
                                           .keyboardType(.emailAddress)
                                           .frame(width: 300, height: 10)
                                           .disableAutocorrection(true)
                                           .onChange(of: email) { _ in validateEmail() }
                                   }
                                   .padding()
                                               .background(
                                                   RoundedRectangle(cornerRadius: 10)
                                                       .stroke(Color.black, lineWidth: 1)
                                               )
                                               .padding(.top, 60)
                                               .padding(.horizontal)

                                   if let emailError = emailError {
                                       Text(emailError)
                                           .foregroundColor(.red)
                                           .font(.caption)
                                           .padding([.leading, .top], 20)
                                   }
                               }

                // Password Field
                VStack(alignment: .leading) {
                    HStack {
                        Image(systemName: "lock")
                            .foregroundColor(.gray)
                        if isPasswordVisible {
                            TextField("Password", text: $password)
                                .frame(height: 0) // Set the fixed height
                                .frame(maxWidth: .infinity) // Make the field fill available space
                        } else {
                            SecureField("Password", text: $password)
                                .frame(height: 0) // Set the fixed height
                                .frame(maxWidth: .infinity) // Make the field fill available space
                        }
                        Button(action: {
                            isPasswordVisible.toggle()
                        }) {
                            Image(systemName: isPasswordVisible ? "eye.slash.fill" : "eye.fill")
                                .foregroundColor(isPasswordVisible ? .gray : .blue)
                        }
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.black, lineWidth: 1)
                    )
                    .padding(.top, -10)
                    .padding(.horizontal)
                    
                    if let passwordError = passwordError {
                        Text(passwordError)
                            .foregroundColor(.red)
                            .font(.caption)
                            .padding([.leading, .top], 20)
                    }
                }
                .frame(maxWidth: 500) // Set a fixed width for the whole VStack to avoid resizing


                // Log In Button
                NavigationLink(destination: HomeView(), isActive: $isLoggedIn) {
                    EmptyView()
                }
                Button(action: {
                    if validateFields() {
                        Auth.auth().signIn(withEmail: email, password: password) {  authResult, error in
                            if let error = error {
                                print(error)
                                    return
                            }
                            if let authResult = authResult {
                                currentuser.id = authResult.user.uid
                                    print("logged in")
                                    isLoggedIn = true
                                DataController.shared.fecthDocter()
                                DataController.shared.fetchLabTests()
                                    HomeView()
                            }
                        }
                    }
                }) {
                    Text("Log In")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
                .padding(.top, 30)

                if let loginError = loginError {
                    Text(loginError)
                        .foregroundColor(.red)
                        .font(.caption)
                        .padding(.horizontal)
                }

                NavigationLink(destination: CreateAccountView(), isActive: $createAccountButtonTapped) {
                    EmptyView()
                }
                // Link to Create Account
                Button(action: {
                    createAccountButtonTapped = true
                }) {
                    Text("Create Account")
                        .font(.subheadline)
                        .foregroundColor(.blue)
                }
                .padding(.top, -20)

                Spacer()
            }
            .navigationTitle("")
            .navigationBarHidden(true)
        }
    }

    private func validateEmail() {
        if email.isEmpty {
            emailError = "Email is required."
        } else if !isValidEmail(email) {
            emailError = "Invalid email format."
        } else {
            emailError = nil
        }
    }

    private func validatePassword() {
        if password.isEmpty {
            passwordError = "Password is required."
        } else {
            passwordError = nil
        }
    }

    private func validateFields() -> Bool {
        validateEmail()
        validatePassword()
        return emailError == nil && passwordError == nil
    }

    private func isValidEmail(_ email: String) -> Bool {
        // Basic regex to check general email pattern
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Z0-9a-z.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        
        // Check if email matches the basic pattern
        guard emailTest.evaluate(with: email) else { return false }
        
        // No spaces
        guard !email.contains(" ") else { return false }
        
        // Total length within 320 characters
        guard email.count <= 320 else { return false }
        
        // Split the email into local and domain parts
        let emailParts = email.split(separator: "@")
        guard emailParts.count == 2 else { return false }
        
        let localPart = String(emailParts[0])
        let domainPart = String(emailParts[1])
        
        // Local part length within 64 characters
        guard localPart.count <= 64 else { return false }
        
        // No consecutive dots in local or domain part
        guard !localPart.contains("..") && !domainPart.contains("..") else { return false }
        
        // Local part does not start or end with a dot
        guard !localPart.hasPrefix(".") && !localPart.hasSuffix(".") else { return false }
        guard !localPart.hasSuffix(".") && !domainPart.hasPrefix(".") else { return false }
        
        // Validate domain part against a list of authentic domains
        let authenticDomains = [
            "gmail.com", "yahoo.com", "hotmail.com","apple.co"
            // Add more domains as needed
        ]
        guard authenticDomains.contains(domainPart) else { return false }
        
        return true
    }

    private func isValidPassword(_ password: String) -> Bool {
        // Check if password is empty
        if password.isEmpty {
            return false
        }

        return password.count <= 8
    }
}

struct LogInView_Previews: PreviewProvider {
    static var previews: some View {
        LogInView()
    }
}
