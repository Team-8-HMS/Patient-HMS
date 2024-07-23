
import SwiftUI
import FirebaseFirestore

struct PrescriptionsView: View {
    class PrescriptionsViewModel: ObservableObject {
        @Published var prescriptions: [LivePrescriptions] = []
        private var db = Firestore.firestore()

        func fetchPrescriptions() {
            db.collection("prescriptions").getDocuments { querySnapshot, error in
                if let error = error {
                    print("Error fetching documents: \(error.localizedDescription)")
                } else {
                    if let documents = querySnapshot?.documents {
                        self.prescriptions = documents.compactMap { document in
                            let data = document.data()
                            let imageURL = data["imageURL"] as? String
                            return LivePrescriptions(id: document.documentID, image: imageURL)
                        }
                    } else {
                        print("No documents found")
                    }
                }
            }
        }
    }
    
    @StateObject private var viewModel = PrescriptionsViewModel()

    var body: some View {
                    List(viewModel.prescriptions) { prescription in
                HStack {
                    if let imageURL = prescription.image {
                      
                        AsyncImage(url: URL(string: imageURL)) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 100, height: 200)
                                
                        } placeholder: {
                            ProgressView()
                        }
                    }
                }.padding(.leading, 120)
            }
            .navigationTitle("Prescriptions")
            
            .onAppear {
                viewModel.fetchPrescriptions()
            }
        }
    
}
