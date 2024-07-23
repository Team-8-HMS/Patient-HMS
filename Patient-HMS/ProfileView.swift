//
//  ProfileView.swift
//  Patient-HMS
//
//  Created by IOS on 18/07/24.
//

import FirebaseFirestore
import FirebaseStorage
import Combine
import Foundation
import SwiftUI
import FirebaseAuth


class PatientFirestoreService: ObservableObject {
    @Published var patientProfile: PatientProfile?
    @Published var profileImage: UIImage?

    private var db = Firestore.firestore()

    func fetchCurrentUserProfile() {
        guard let user = Auth.auth().currentUser else {
            print("No authenticated user")
            return
        }

        let uid = user.uid
        db.collection("Patient").document(uid).getDocument { (document, error) in
            if let document = document, document.exists {
                do {
                    self.patientProfile = try document.data(as: PatientProfile.self)
                    if let imageURL = self.patientProfile?.imageURL {
                        self.downloadImage(from: imageURL)
                    }
                } catch {
                    print("Error decoding document: \(error)")
                }
            } else {
                print("Document does not exist")
            }
        }
    }

    private func downloadImage(from url: String) {
        let storageRef = Storage.storage().reference(forURL: url)
        storageRef.getData(maxSize: 5 * 1024 * 1024) { data, error in
            if let error = error {
                print("Error downloading image: \(error)")
                return
            }
            if let data = data {
                self.profileImage = UIImage(data: data)
            }
        }
    }

    func updateUserProfile(_ profile: PatientProfile, completion: @escaping (Error?) -> Void) {
        guard let user = Auth.auth().currentUser else {
            print("No authenticated user")
            return
        }

        let uid = user.uid
        do {
            try db.collection("Patient").document(uid).setData(from: profile) { error in
                if let error = error {
                    print("Error updating document: \(error)")
                    completion(error)
                } else {
                    self.patientProfile = profile
                    completion(nil)
                }
            }
        } catch {
            print("Error encoding document: \(error)")
            completion(error)
        }
    }
}



struct PatientProfile : Identifiable, Codable{
    var id :String
    var firstname: String
    var lastname:String
    var imageURL:String
    var dob: Date
    var gender: String
    var contactNumber: String
    var email: String
    var address: String
    var emergencyContact: String
}

struct ProfileView: View {
    @ObservedObject var patientService = PatientFirestoreService()
    @State private var isEditing = false
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    // Action to edit profile
                    self.isEditing = true
                }) {
                    Text("Edit")
                        .foregroundColor(.blue)
                }
                .padding([.trailing,.top], 20)
            }
            
            ScrollView {
                VStack {
                    // Profile Card
                    if let profileImage = patientService.profileImage {
                        Image(uiImage: profileImage)
                            .resizable()
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                            .padding([.bottom, .top], 10)
                    } else {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .frame(width: 100, height: 100)
                            .foregroundColor(.gray)
                            .padding([.bottom, .top], 10)
                    }
                    
                    if let patientProfile = patientService.patientProfile {
                        Text("\(patientProfile.firstname) \(patientProfile.lastname)")
                            .fontWeight(.bold)
                            .padding(.bottom, 30)
                        
                        VStack(alignment: .leading, spacing: 10) {
                            ProfileInfoRow(label: "First Name", value: patientProfile.firstname)
                            Divider()
                            ProfileInfoRow(label: "Last Name", value: patientProfile.lastname)
                            Divider()
                            ProfileInfoRow(label: "Date of Birth", value: dateToString(patientProfile.dob))
                            Divider()
                            ProfileInfoRow(label: "Gender", value: patientProfile.gender)
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 30)
                        
                        VStack(alignment: .leading, spacing: 10) {
                            ProfileInfoRow(label: "Contact No", value: patientProfile.contactNumber)
                            Divider()
                            ProfileInfoRow(label: "Emergency Contact", value: patientProfile.emergencyContact)
                            Divider()
                            ProfileInfoRow(label: "Email", value: patientProfile.email)
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 30)
                        
                        VStack(alignment: .leading, spacing: 10) {
                            ProfileInfoRow(label: "Address", value: patientProfile.address)
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 10)
                    } else {
                        ProgressView()
                            .padding()
                    }
                    
                    Spacer()
                }
                .background(Color(UIColor.systemGray6).edgesIgnoringSafeArea(.all))
                .onAppear {
                    patientService.fetchCurrentUserProfile()
                }
            }
        }
        .background(Color(UIColor.systemGray6))
        .sheet(isPresented: $isEditing) {
            if let profile = self.patientService.patientProfile {
                           EditProfileView(patientProfile: Binding(
                               get: { profile },
                               set: { newValue in self.patientService.patientProfile = newValue }
                           ))
                       }
                   }
    }
    
    func dateToString(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}



struct ProfileInfoRow: View {
    var label: String
    var value: String
    
    var body: some View {
        HStack {
            Text(label)
                .font(.headline)
                .foregroundColor(.gray)
            Spacer()
            Text(value)
                .font(.subheadline)
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}










struct EditProfileView: View {
    @Binding var patientProfile: PatientProfile
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var patientService = PatientFirestoreService()

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Personal Information")) {
                    TextField("First Name", text: $patientProfile.firstname)
                    TextField("Last Name", text: $patientProfile.lastname)
                    DatePicker("Date of Birth", selection: Binding<Date>(
                        get: { self.patientProfile.dob },
                        set: { self.patientProfile.dob = $0 }
                    ), displayedComponents: .date)
                    Picker("Gender", selection: $patientProfile.gender) {
                        Text("Male").tag("Male")
                        Text("Female").tag("Female")
                    }
                }

                Section(header: Text("Contact Information")) {
                    TextField("Contact Number", text: $patientProfile.contactNumber)
                    TextField("Emergency Contact", text: $patientProfile.emergencyContact)
                    TextField("Email", text: $patientProfile.email)
                }

                Section(header: Text("Address")) {
                    TextField("Address", text: $patientProfile.address)
                }
            }
            .navigationBarTitle("Edit Profile")
            .navigationBarItems(trailing:
                                    Button(action: {
                                        patientService.updateUserProfile(patientProfile) { error in
                                            if error == nil {
                                                self.presentationMode.wrappedValue.dismiss()
                                            }
                                        }
                                    }) {
                                        Text("Save")
                                    }
            )
        }
    }
}
