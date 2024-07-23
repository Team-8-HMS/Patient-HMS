import SwiftUI
import Firebase
import FirebaseStorage

struct AddRecordDetailsView: View {
    @State private var selectedFamilyMember = ""
    @State private var fileName = ""
    @State private var recordDate = Date()
    @State private var selectedType: String?
    @State private var isShowingImagePicker = false
    @State private var selectedImages: [UIImage] = []
    @State private var imagePickerSourceType: UIImagePickerController.SourceType = .photoLibrary
    @State private var patientID = ""

    @Environment(\.presentationMode) var presentationMode
    @Binding var records: [MedicalRecord]

    // Firestore reference
    private var db = Firestore.firestore()
    private let storage = Storage.storage()

    init(records: Binding<[MedicalRecord]>) {
        self._records = records
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(selectedImages, id: \.self) { image in
                                Image(uiImage: image)
                                    .resizable()
                                    .frame(width: 100, height: 100)
                                    .cornerRadius(10)
                            }
                            Button(action: {
                                imagePickerSourceType = .photoLibrary
                                isShowingImagePicker = true
                            }) {
                                VStack {
                                    Image(systemName: "plus")
                                        .resizable()
                                        .frame(width: 26, height: 26)
                                        .foregroundColor(.gray)
                                    Text("Add images")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                                .frame(width: 100, height: 100)
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(10)
                            }
                        }
                    }
                    .padding()
                    .padding(.leading, 12)

                    VStack(alignment: .leading, spacing: 0) {
                        // Picker
                        Picker("Select family member", selection: $selectedFamilyMember) {
                            Text("Select family member").tag("")
                            Text("Myself").tag("Myself")
                            Text("Family Member").tag("Family Member")
                        }
                        .padding()
                        .cornerRadius(10, corners: [.topLeft, .topRight])

                        Divider()

                        // TextField
                        TextField("Add file name", text: $fileName)
                            .padding()
                            .padding(.horizontal, 12)
                            .frame(width: 361, height: 51)

                        Divider()

                        // DatePicker
                        DatePicker("Add record date", selection: $recordDate, displayedComponents: .date)
                            .padding()
                            .padding(.horizontal, 12)
                            .cornerRadius(10, corners: [.bottomLeft, .bottomRight])
                    }
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                    .padding(24)

                    HStack {
                        RecordTypeButton(type: "Lab Report", selectedType: $selectedType)
                            .foregroundColor(Color("Color 1"))

                        RecordTypeButton(type: "Medical Report", selectedType: $selectedType)
                            .foregroundColor(Color("Color 1"))
                    }
                    .padding(.vertical)
                    .frame(width: 361, height: 51)
                    .padding(25)

                    Spacer()
                }
                .padding()
                .sheet(isPresented: $isShowingImagePicker) {
                    CustomImagePicker(selectedImages: $selectedImages, sourceType: imagePickerSourceType)
                }
            }
            .navigationBarTitle("New Record", displayMode: .inline)
            .navigationBarItems(
                leading: Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Cancel")
                        .foregroundColor(.red)
                },
                trailing: Button(action: {
                    saveRecord()
                }) {
                    Text("Save")
                        .foregroundColor(.red)
                }
            )
        }
    }

    private func saveRecord() {
        // Prepare data for Firestore
        var recordData: [String: Any] = [
            "familyMember": selectedFamilyMember,
            "fileName": fileName,
            "date": Timestamp(date: recordDate),
            "type": selectedType ?? "",
            "patientID": currentuser.id
        ]

        // Upload images to Firebase Storage
        let group = DispatchGroup()
        var imageUrls: [String] = []

        for image in selectedImages {
            group.enter()
            uploadImage(image) { url in
                if let url = url {
                    imageUrls.append(url.absoluteString)
                }
                group.leave()
            }
        }

        group.notify(queue: .main) {
            recordData["images"] = imageUrls

            // Save record to Firestore
            db.collection("medicalRecords").addDocument(data: recordData) { error in
                if let error = error {
                    print("Error saving record: \(error.localizedDescription)")
                } else {
                    print("Record saved successfully!")
                    let newRecord = MedicalRecord(id: UUID().uuidString, data: recordData)
                    self.records.append(newRecord)
                    self.presentationMode.wrappedValue.dismiss()
                }
            }
        }
    }

    private func uploadImage(_ image: UIImage, completion: @escaping (URL?) -> Void) {
        let storageRef = storage.reference().child("images/\(UUID().uuidString).jpg")
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            completion(nil)
            return
        }

        storageRef.putData(imageData, metadata: nil) { metadata, error in
            if let error = error {
                print("Error uploading image: \(error.localizedDescription)")
                completion(nil)
                return
            }

            storageRef.downloadURL { url, error in
                if let error = error {
                    print("Error getting download URL: \(error.localizedDescription)")
                    completion(nil)
                    return
                }

                completion(url)
            }
        }
    }
}

struct RecordTypeButton: View {
    let type: String
    @Binding var selectedType: String?

    var body: some View {
        Button(action: {
            selectedType = type
        }) {
            VStack {
                Image(systemName: "doc.fill")
                    .font(.largeTitle)
                Text(type)
                    .font(.footnote)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(selectedType == type ? Color.blue.opacity(0.2) : Color.gray.opacity(0.2))
            .cornerRadius(10)
        }
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

struct AddRecordDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        AddRecordDetailsView(records: .constant([]))
    }
}
