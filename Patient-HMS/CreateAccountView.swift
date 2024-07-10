import SwiftUI
import UIKit
import FirebaseAuth
import FirebaseFirestore

struct ImagePicker: UIViewControllerRepresentable {
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        
        var navToLogin = false
        let parent: ImagePicker
        init(parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.selectedImage = image
            }
            parent.presentationMode.wrappedValue.dismiss()
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }

    @Environment(\.presentationMode) var presentationMode
    @Binding var selectedImage: UIImage?
    var sourceType: UIImagePickerController.SourceType

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = sourceType
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
}



struct CreateAccountView: View {
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var gender: String = "Male"
    @State private var age: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var errorMessage = ""
    @State private var isLoggedIn = false
    @Environment(\.presentationMode) var presentationMode
    
    let genders = ["Male", "Female", "Other"]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Spacer()
                
                // Illustration
                Image("CreateAccount")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 211, height: 170)
                    .padding(.bottom, 50)
                
                // First Name Field
                TextFieldWithValidation(title: "First Name", text: $firstName, errorMessage: errorMessage(for: .firstName))
                
                // Last Name Field
                TextFieldWithValidation(title: "Last Name", text: $lastName, errorMessage: errorMessage(for: .lastName))
                
                // Gender Field
                Picker(selection: $gender, label: Text("Gender")) {
                    ForEach(genders, id: \.self) {
                        Text($0)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                
                // Age Field
                TextFieldWithValidation(title: "Age", text: $age, errorMessage: errorMessage(for: .age))
                    .keyboardType(.numberPad)
                
                // Email Field
                TextFieldWithValidation(title: "Email ID", text: $email, errorMessage: errorMessage(for: .email))
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                
                // Password Field
                VStack(alignment: .leading) {
                    HStack {
                        Image(systemName: "lock")
                            .foregroundColor(.gray)
                        SecureField("Password", text: $password)
                            .padding(.horizontal)
                            .frame(height: 25)
                            .onTapGesture {
                                errorMessage = ""
                            }
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray))
                    .padding(.horizontal)
                    
                    if !errorMessage.isEmpty {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .font(.caption)
                            .padding(.horizontal)
                    }
                }
                NavigationLink(destination:LogInView(),isActive: $isLoggedIn){
                    EmptyView()
                }
                // Sign Up Button
                Button(action: {
                    // Handle Sign Up
                    errorMessage = validateFields()
                    if errorMessage.isEmpty {
                        let db = Firestore.firestore()
                        do{
                            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                                if let error = error {
                                    print("Error: \(error.localizedDescription)")
                                } else {
                                    if let authResult = authResult {
                                        let userID = authResult.user.uid
                                        let newPatient = Patient(id: "\(userID)", FirstName:firstName, LastName: lastName, image: "", dob: Date.now, gender: gender, contactNumber:"" , email: email, address: "", emergencyContact: "", upcomingAppointments: [], previousDoctors: [])
                                        let PatientData = newPatient.toDictionary()
                                        do {
                                            try db.collection("Patient").document(userID).setData(PatientData)
                                            db.collection("All Users").document(newPatient.email).setData(["Patient": 1])
                                            currentuser = newPatient
                                            isLoggedIn = true
                                        } catch {
                                            print("Error setting patient data: \(error.localizedDescription)")
                                        }
                                    }
                                }
                            }
                        }
                    }
                }) {
                    Text("Create Account")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
                .padding(.top, 30)
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text("Account Created"),
                        message: Text(alertMessage),
                        dismissButton: .default(Text("OK")) {
                            presentationMode.wrappedValue.dismiss()
                        }
                    )
                }
                
                Spacer()
            }
            .padding(.horizontal)
            .navigationTitle("Create Account")
        }
    }
    
    private enum Field {
        case firstName, lastName, age, email
        
        var title: String {
            switch self {
            case .firstName: return "First Name"
            case .lastName: return "Last Name"
            case .age: return "Age"
            case .email: return "Email ID"
            }
        }
    }
    
    private func validateFields() -> String {
        var errorMessages = [String]()
        
        if firstName.isEmpty {
            errorMessages.append("First name is required")
        } else if !isValidName(firstName) {
            errorMessages.append("Enter a valid first name")
        }
        
        if lastName.isEmpty {
            errorMessages.append("Last name is required")
        } else if !isValidName(lastName) {
            errorMessages.append("Enter a valid last name")
        }
        if firstName.lowercased() == lastName.lowercased() {
            errorMessages.append("First name and last name cannot be the same")
        }
        
        if age.isEmpty {
            errorMessages.append("Age is required")
        } else if !isValidAge(age) {
            errorMessages.append("Enter a valid age")
        }
        
        if email.isEmpty {
            errorMessages.append("Email is required")
        } else if !isValidEmail(email) {
            errorMessages.append("Enter a valid email address")
        }
        
        if password.isEmpty {
            errorMessages.append("Password is required")
        } else if let passwordError = passwordValidationError(password) {
            errorMessages.append(passwordError)
        }
        
        return errorMessages.joined(separator: "\n")
    }
    
    private func isValidName(_ name: String) -> Bool {
        let nameRegEx = "^[a-zA-Z]+$"  // Only allow alphabetic characters
        let namePred = NSPredicate(format: "SELF MATCHES %@", nameRegEx)
        return namePred.evaluate(with: name) && !name.contains(".") && !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    private func isValidAge(_ age: String) -> Bool {
        let ageRegEx = "^[0-9]+$"  // Only allow numeric characters
        let agePred = NSPredicate(format: "SELF MATCHES %@", ageRegEx)
        return agePred.evaluate(with: age)
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        // Ensure the email is not empty and does not contain spaces
        guard !email.isEmpty, !email.contains(" "), email.count <= 320 else {
            return false
        }
        
        // Ensure the email contains exactly one '@' symbol
        let emailParts = email.split(separator: "@")
        guard emailParts.count == 2 else {
            return false
        }
        
        let localPart = emailParts[0]
        let domainPart = emailParts[1]
        
        // Ensure local part is not empty and does not exceed 64 characters
        guard !localPart.isEmpty, localPart.count <= 64 else {
            return false
        }
        
        // Ensure no consecutive dots in local or domain part, and no leading/trailing dots
        guard !localPart.contains(".."), !domainPart.contains(".."),
              !localPart.hasPrefix("."), !localPart.hasSuffix("."),
              !domainPart.hasPrefix("."), !domainPart.hasSuffix(".") else {
            return false
        }
        
        // Ensure the email starts with a lowercase letter
        guard localPart.first?.isLowercase == true else {
            return false
        }
        
        // Ensure the email conforms to valid character rules
        let localPartRegEx = "^[a-zA-Z0-9._%+-]+$"
        let localPartTest = NSPredicate(format: "SELF MATCHES %@", localPartRegEx)
        guard localPartTest.evaluate(with: String(localPart)) else {
            return false
        }
        
        // Ensure the domain is one of the specified valid domains (e.g., gmail.com, yahoo.com)
        let validDomains = ["gmail.com", "yahoo.com", ".in", ".co", ".net", ".in","apple.co"] // Add more domains as needed
        guard validDomains.contains(domainPart.lowercased()) else {
            return false
        }
        
        return true
    }

    
    
    
    private func passwordValidationError(_ password: String) -> String? {
        if password.count < 8 {
            return "Password must be at least 8 characters long"
        } else if !password.contains(where: { $0.isUppercase }) {
            return "Password must contain at least one uppercase letter"
        } else if !password.contains(where: { $0.isNumber }) {
            return "Password must contain at least one number"
        } else if !password.contains(where: { "!@#$%&*".contains($0) }) {
            return "Password must contain at least one special character"
        }
        return nil
    }
    
    private func errorMessage(for field: Field) -> String {
        switch field {
        case .firstName:
            if firstName.isEmpty {
                return "First name is required"
            } else if !isValidName(firstName) {
                return "Enter a valid first name"
            }
        case .lastName:
            if lastName.isEmpty {
                return "Last name is required"
            } else if !isValidName(lastName) {
                return "Enter a valid last name"
            } else if firstName.lowercased() == lastName.lowercased() {
                return "First name and last name cannot be the same"
            }
        case .age:
            if age.isEmpty {
                return "Age is required"
            } else if !isValidAge(age) {
                return "Enter a valid age"
            }
        case .email:
            if email.isEmpty {
                return "Email is required"
            } else if !isValidEmail(email) {
                return "Enter a valid email address"
            }
        }
        return ""
    }
    
    
    struct CreateAccountView_Previews: PreviewProvider {
        static var previews: some View {
            CreateAccountView()
        }
    }
    
    struct TextFieldWithValidation: View {
        let title: String
        @Binding var text: String
        let errorMessage: String
        @State private var isEditing: Bool = false // Track editing state
        
        var body: some View {
            VStack(alignment: .leading) {
                HStack {
                    Image(systemName: "person")
                        .foregroundColor(.gray)
                    TextField(title, text: $text, onEditingChanged: { editing in
                        self.isEditing = editing
                    })
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .padding(.horizontal)
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray))
                .padding(.horizontal)
                
                if isEditing && !errorMessage.isEmpty { // Show error only if editing and error message exists
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.caption)
                        .padding(.horizontal)
                }
            }
        }
    }
    
}
