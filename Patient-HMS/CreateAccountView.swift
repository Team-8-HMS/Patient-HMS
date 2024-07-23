import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

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
    @State private var gender: String = "Select Gender"
    @State private var age: String = ""
    @State private var address: String = ""
    @State private var contactNumber: String = ""
    @State private var emergencyContact: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var errorMessage = ""
    @State private var selectedImage: UIImage?
    @State private var showImagePicker = false
    @State private var imagePickerSourceType: UIImagePickerController.SourceType = .photoLibrary
    @State private var isLoggedIn = false
    @Environment(\.presentationMode) var presentationMode
    
    let genders = ["Select Gender","Male", "Female", "Other"]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Spacer()
                
                // Profile Photo
                if let selectedImage = selectedImage {
                    Image(uiImage: selectedImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.gray, lineWidth: 2))
                } else {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100)
                        .foregroundColor(.gray)
                }
                Button(action: {
                    self.showImagePicker = true
                    self.imagePickerSourceType = .photoLibrary
                }) {
                    Text("Select Photo")
                        .foregroundColor(.blue)
                }
                .padding(.bottom, 20)
                .sheet(isPresented: $showImagePicker) {
                    ImagePicker(selectedImage: $selectedImage, sourceType: self.imagePickerSourceType)
                }
                
                // First Name Field
                TextFieldWithValidation(title: "First Name", text: $firstName, errorMessage: errorMessage(for: .firstName))
                
                // Last Name Field
                TextFieldWithValidation(title: "Last Name", text: $lastName, errorMessage: errorMessage(for: .lastName))
                
                // Gender Field
                HStack {
                                   
                                    Text("Gender").padding(20)
                                    Spacer()
                                    Picker(selection: $gender, label: Text("Gender")) {
                                        ForEach(genders, id: \.self) {
                                            Text($0)
                                        }
                                    }
                                    .pickerStyle(MenuPickerStyle())
                                }
                .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray))
                .padding(.horizontal)

                // Age Field
                TextFieldWithValidation(title: "Age", text: $age, errorMessage: errorMessage(for: .age))
                    .keyboardType(.numberPad)
                
                // Address Field
                TextFieldWithValidation(title: "Address", text: $address, errorMessage: errorMessage(for: .address))
                
                // Contact Number Field
                TextFieldWithValidation(title: "Contact Number", text: $contactNumber, errorMessage: errorMessage(for: .contactNumber))
                    .keyboardType(.numberPad)
                    .onChange(of: contactNumber) { newValue in
                        if newValue.count > 10 {
                            errorMessage = "Contact number cannot exceed 10 digits"
                        } else {
                            errorMessage = ""
                        }
                    }
                
                // Emergency contact number Field
                TextFieldWithValidation(title: "Emergency Contact Number", text: $emergencyContact, errorMessage: errorMessage(for: .emergencyContact))
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
                            .foregroundColor(.gray)
                            .font(.caption)
                            .padding(.horizontal)
                    }
                }
                
                // Sign Up Button
                Button(action: {
                    // Handle Sign Up
                    errorMessage = validateFields()
                    if errorMessage.isEmpty {
                        createAccount()
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
        case firstName, lastName, age, address, contactNumber, emergencyContact, email
        
        var title: String {
            switch self {
            case .firstName: return "First Name"
            case .lastName: return "Last Name"
            case .age: return "Age"
            case .address: return "Address"
            case .contactNumber: return "Contact Number"
            case .emergencyContact: return "Emergency Contact Number"
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
        } else if firstName.lowercased() == lastName.lowercased() {
            errorMessages.append("First name and last name cannot be the same")
        }
        
        if age.isEmpty {
            errorMessages.append("Age is required")
        } else if !isValidAge(age) {
            errorMessages.append("Enter a valid age")
        } else if let ageInt = Int(age), ageInt < 15 {
            errorMessages.append("Age must be at least 15 years old")
        }
        
        if address.isEmpty {
            errorMessages.append("Address is required")
        }
        
        if contactNumber.isEmpty {
            errorMessages.append("Contact number is required")
        } else if !isValidPhoneNumber(contactNumber) {
            errorMessages.append("Enter a valid 10-digit contact number")
        }
        
        if emergencyContact.isEmpty {
            errorMessages.append("Emergency contact number is required")
        } else if !isValidPhoneNumber(emergencyContact) {
            errorMessages.append("Enter a valid 10-digit emergency contact number")
        } else if contactNumber == emergencyContact {
            errorMessages.append("Emergency contact number should be different from contact number")
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
    
    private func errorMessage(for field: Field) -> String {
        switch field {
        case .firstName:
            if firstName.isEmpty {
                return ""
            } else if !isValidName(firstName) {
                return "Enter a valid first name"
            }
        case .lastName:
            if lastName.isEmpty {
                return ""
            } else if !isValidName(lastName) {
                return "Enter a valid last name"
            } else if firstName.lowercased() == lastName.lowercased() {
                return "First name and last name cannot be the same"
            }
        case .age:
            if age.isEmpty {
                return ""
            } else if !isValidAge(age) {
                return "Enter a valid age"
            } else if let ageInt = Int(age), ageInt < 15 {
                return "Age must be at least 15 years old"
            }
        case .address:
            if address.isEmpty {
                return ""
            }
        case .contactNumber:
            if contactNumber.isEmpty {
                return ""
            } else if !isValidPhoneNumber(contactNumber) {
                return "Enter a valid 10-digit contact number"
            }
        case .emergencyContact:
            if emergencyContact.isEmpty {
                return ""
            } else if !isValidPhoneNumber(emergencyContact) {
                return "Enter a valid 10-digit emergency contact number"
            } else if contactNumber == emergencyContact {
                return "Emergency contact number should be different from contact number"
            }
        case .email:
            if email.isEmpty {
                return ""
            } else if !isValidEmail(email) {
                return "Enter a valid email address"
            }
        }
        return ""
    }
    
    private func isValidName(_ name: String) -> Bool {
        let nameRegex = "^[a-zA-Z]+(?:\\s[a-zA-Z]+)?$"
        let namePredicate = NSPredicate(format: "SELF MATCHES %@", nameRegex)
        return namePredicate.evaluate(with: name)
    }
    
    private func isValidAge(_ age: String) -> Bool {
        let ageRegex = "^[0-9]+$"
        let agePredicate = NSPredicate(format: "SELF MATCHES %@", ageRegex)
        return agePredicate.evaluate(with: age)
    }
    
    private func isValidPhoneNumber(_ phoneNumber: String) -> Bool {
        let phoneRegex = "^\\d{10}$"
        let phonePredicate = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phonePredicate.evaluate(with: phoneNumber)
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    private func passwordValidationError(_ password: String) -> String? {
        // Regular expression to check for at least one lowercase letter, one uppercase letter, one digit, and one special character
        let passwordRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[@$!%?&])[A-Za-z\\d@$!%?&]{8,}$"
        let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        
        if password.count < 8 {
            return "Password must be at least 8 characters long"
        } else if !passwordPredicate.evaluate(with: password) {
            return "Password must contain at least one uppercase letter, one lowercase letter, one number, and one special character"
        }
        return nil
    }

    
    private func createAccount() {
        guard let selectedImage = selectedImage else {
            errorMessage = "Please select a profile photo"
            return
        }
        
        // Upload image to Firebase Storage
        let imageName = UUID().uuidString
        let storageRef = Storage.storage().reference().child("profile_images/\(imageName).jpg")
        
        if let imageData = selectedImage.jpegData(compressionQuality: 0.8) {
            storageRef.putData(imageData, metadata: nil) { metadata, error in
                if let error = error {
                    self.errorMessage = "Error uploading image: \(error.localizedDescription)"
                    return
                }
                
                storageRef.downloadURL { url, error in
                    if let error = error {
                        self.errorMessage = "Error fetching download URL: \(error.localizedDescription)"
                        return
                    }
                    
                    guard let downloadURL = url else {
                        self.errorMessage = "Failed to fetch download URL"
                        return
                    }
                    
                    let profileImageUrl = downloadURL.absoluteString
                    
                    // Create the user account in Firebase Authentication
                    Auth.auth().createUser(withEmail: self.email, password: self.password) { authResult, error in
                        if let error = error {
                            self.errorMessage = "Error creating user: \(error.localizedDescription)"
                            return
                        }
                        
                        guard let user = authResult?.user else {
                            self.errorMessage = "Failed to retrieve user"
                            return
                        }
                        
                        // Save user details in Firestore
                        let db = Firestore.firestore()
                        db.collection("Patient").document(user.uid).setData([
                            "firstname": self.firstName,
                            "lastname": self.lastName,
                            "gender": self.gender,
                            "age": self.age,
                            "address": self.address,
                            "contactNumber": self.contactNumber,
                            "emergencyContact": self.emergencyContact,
                            "email": self.email,
                            "imageURL": profileImageUrl
                        ]) { error in
                            if let error = error {
                                self.errorMessage = "Error saving user details: \(error.localizedDescription)"
                                return
                            }
                            
                            // Account creation successful
                            self.alertMessage = "Account created successfully"
                            self.showAlert = true
                        }
                    }
                }
            }
        } else {
            errorMessage = "Failed to convert image to data"
        }
    }
}

struct TextFieldWithValidation: View {
    let title: String
    @Binding var text: String
    var errorMessage: String
    @State private var showingError = false
    
    var body: some View {
        VStack(alignment: .leading) {
            TextField(title, text: $text) { isEditing in
                if isEditing {
                    showingError = true
                }
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray))
            .padding(.horizontal)
            
            if showingError && !errorMessage.isEmpty {
                Text(errorMessage)
                    .foregroundColor(.gray)
                    .font(.caption)
                    .padding(.horizontal)
            }
        }
    }
}

struct CreateAccountView_Previews: PreviewProvider {
    static var previews: some View {
        CreateAccountView()
    }
}
