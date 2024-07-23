import SwiftUI

// Model representing a consultant
struct Consultant: Identifiable {
    let id = UUID()
    let name: String
    let department: String
    let degree: String
    let yearsOfExperience: String
    let consultations: String
    let image: UIImage?
}

// Main view for instant consultation
struct InstantConsultView: View {
    @State private var showPaymentConfirmation = false
    @State private var showFaceTimeScreen = false
    @State private var paymentAmount: String = "₹500"
    
    // Sample data for consultants
//    let consultants = [
//        Consultant(
//            name: "Emergency Consult",
//            department: "General Physician",
//            degree: "MD",
//            yearsOfExperience: "7 years",
//            consultations: "",
//            image: UIImage(named: "doctor")
//        )
//    ]
    
    var body: some View {
        NavigationView {
            VStack {
                // Title Section
                VStack(alignment: .leading, spacing: 8) {
                    Text("Instant Consult 24/7 ")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                }
                .padding([.leading, .top])
                                
                                Spacer()
                                    .frame(height: 50)
                
                //Info
                
                VStack(alignment: .leading, spacing: 8) {
//                                    Text("")
//                                        .font(.headline)
//                                        .padding(.bottom, 4)
//
                                    Text("You can get Quick and reliable access to emergency medical care through video consultations with qualified doctors.")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                        .padding(.bottom, 20)
                                }
                                .padding(.horizontal)
                
                                 Divider()
                
                // Consultation Options Section
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Single online consultation")
                            .font(.headline)
                        
                        Spacer()
                        
                        Text("₹ 500")
                            .font(.headline)
                    }
                    
                    Text("Video consultation ")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
//                    Text("₹ 649.00")
//                        .font(.subheadline)
//                        .foregroundColor(.gray)
//                        .strikethrough()
                    
                    
                }
                .padding(.horizontal)
                .padding()
                
                Spacer()
                
                // Payment Section
                VStack {
                    Button(action: {
                        showPaymentConfirmation = true
                    }) {
                        Text("\(paymentAmount) | Pay & Consult")
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color("Color 1"))
                            .cornerRadius(10)
                    }
                    .padding()
                }
                .alert(isPresented: $showPaymentConfirmation) {
                    Alert(
                        title: Text("Confirm Payment"),
                        message: Text("Do you want to confirm the payment?"),
                        primaryButton: .default(Text("Yes")) {
                            showFaceTimeScreen = true
                        },
                        secondaryButton: .cancel(Text("Cancel"))
                    )
                }
            }
           
            .onAppear {
                fetchPaymentAmount()
            }
            .sheet(isPresented: $showFaceTimeScreen) {
                FaceTimeView()
            }
        }
        .padding(/*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
    }
    
    // Simulate fetching payment amount from the backend
    func fetchPaymentAmount() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.paymentAmount = "₹500"
        }
    }
}

// View for FaceTime call screen
struct FaceTimeView: View {
    var body: some View {
        VStack {
            Text("Payment Confirmed")
                .font(.largeTitle)
                .padding()
            
            FacetimeButton(address: "darshugupta12345@gmail.com")
        }
        .padding()
    }
}

// Button to initiate FaceTime call
//struct FacetimeButton: View {
//    @Environment(\.openURL) var openURL
//    var address: String
//
//    var body: some View {
//        Button(action: {
//            makeCall(to: address.trimmingCharacters(in: .whitespacesAndNewlines))
//        }) {
//            Label("Make FaceTime Call", systemImage: "video.fill")
//        }
//        .buttonStyle(.bordered)
//    }
//
//    private func makeCall(to: String) {
//        guard !to.isEmpty else {
//            print("Error: Email address is empty.")
//            return
//        }
//
//        guard let url = URL(string: "facetime://\(to)"), UIApplication.shared.canOpenURL(url) else {
//            print("Error: Invalid URL or FaceTime not available for this address.")
//            return
//        }
//
//        openURL(url)
//        print("Attempting to call \(to) via FaceTime")
//    }
//}

// Preview for the main view
struct InstantConsultView_Previews: PreviewProvider {
    static var previews: some View {
        InstantConsultView()
    }
}
