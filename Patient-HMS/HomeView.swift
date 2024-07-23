
///Original file

import SwiftUI
import Firebase

struct HomeView: View {
    @State private var isShowingOverlay = false
    @State private var isShowingOverlayProfile = false
    @State private var showAlert = false
    @State private var isRescheduling = false
    @State private var isAppointmentCancelled = false
    @State private var appointmentDate = Date()
    @State private var appointmentTimeSlot: String? = "10:00 - 11:00 am"
    @State private var showPaymentPopup = false
    @StateObject var viewModel = AppointmentCard()
    @State private var isloggedOut : Bool = false
    
    var patientId = currentuser.id
    @ObservedObject var patientService = PatientFirestoreService()
    
    var body: some View {
        NavigationView {
            ZStack {
                // Set the background color for the whole screen
                Color("backgroundColor")
                    .ignoresSafeArea()
                
                // Add blobs as background images
                ZStack {
                    Image("blob1")
                        .aspectRatio(contentMode: .fill)
                        .frame(width: UIScreen.main.bounds.width, height: 300)
                        .offset(x: UIScreen.main.bounds.width / 2, y: -UIScreen.main.bounds.height / 2.5)
                    
                    Image("blob2")
                        .aspectRatio(contentMode: .fill)
                        .frame(width: UIScreen.main.bounds.width, height: 300)
                        .offset(x: -UIScreen.main.bounds.width / 1, y: UIScreen.main.bounds.height / 4.3)
                        .position(x: 170, y: 350)
                    
                    Image("blob3")
                        .aspectRatio(contentMode: .fill)
                        .frame(width: UIScreen.main.bounds.width, height: 300)
                        .offset(x: UIScreen.main.bounds.width / 1.7, y: UIScreen.main.bounds.height / 4)
                    
                    Image("blob3")
                        .aspectRatio(contentMode: .fill)
                        .frame(width: UIScreen.main.bounds.width, height: 300)
                        .offset(x: UIScreen.main.bounds.width / 1.7, y: UIScreen.main.bounds.height / 4)
                }
         
                ScrollView {
                    HStack {
                        Text("Home")
                                                    .font(.largeTitle)
                                                    .fontWeight(.bold)
                                                
                                                Spacer()
                                                
                                                Button(action: {
                                                    isShowingOverlayProfile = true
                                                }) {
                                                    if let profileImage = patientService.profileImage {
                                                        Image(uiImage: profileImage)
                                                            .resizable()
                                                            .frame(width: 40, height: 40)
                                                            .clipShape(Circle())
                                                            .padding()
                                                    } else {
                                                        Image(systemName: "person.crop.circle.fill")
                                                            .frame(width: 40, height: 40)
                                                            .font(.title)
                                                            .foregroundColor(.primary)
                                                            .padding()
                                                    }
                                                }
                                            }
                                            .padding()
                                            .sheet(isPresented: $isShowingOverlayProfile) {
                                                ProfileView()
                                            }
                                            .onAppear {
                                                patientService.fetchCurrentUserProfile()
                                            }
                    VStack {
                        Spacer().frame(height: 20)
                        if !isAppointmentCancelled, let appointment = viewModel.newAppointements.first {
                            ZStack {
                                GroupBox {
                                    VStack(alignment: .leading, spacing: 16) {
                                        Text("Upcoming Appointment")
                                        
                                        HStack {
                                            Image(systemName: "person.crop.circle.fill")
                                                .resizable()
                                                .frame(width: 60, height: 60)
                                                .clipShape(Circle())
                                                .padding(.trailing, 8)
                                            
                                            VStack(alignment: .leading) {
                                                Text(viewModel.doctorDetail.first?.first ?? "Name not found")
                                                    .font(.headline)
                                                
                                                Text(viewModel.doctorDetail.first?.last ?? "")
                                                    .font(.subheadline)
                                            }
                                        }
                                        .padding(.vertical, 3)
                                        
                                        HStack {
                                            HStack {
                                                Image(systemName: "clock.fill")
                                                    .foregroundColor(.white)
                                                
                                                Text(appointment.date)
                                                    .foregroundColor(.white)
                                                    .font(.system(size: 11.5, weight: .bold))
                                                    .lineLimit(1)
                                                Spacer()
                                                Image(systemName: "calendar")
                                                    .foregroundColor(.white)
                                                Text(appointment.timeSlot)
                                                    .foregroundColor(.white)
                                                    .font(.system(size: 10.6, weight: .bold))
                                            }
                                            .padding()
                                            .padding(.vertical, 1)
                                            .background(Color.black)
                                            .cornerRadius(10)
                                            .frame(height: 70)
                                        }
                                    }
                                    .padding(3)
                                    .gesture(
                                        LongPressGesture(minimumDuration: 0.5)
                                            .onEnded { _ in
                                                isShowingOverlay = true
                                            }
                                    )
                                    .contextMenu {
                                        Button(action: {
                                            showAlert = true
                                        }) {
                                            Text("Cancel")
                                            Image(systemName: "trash")
                                        }
                                        Button(action: {
                                            isRescheduling = true
                                        }) {
                                            Text("Reschedule")
                                            Image(systemName: "calendar")
                                        }
                                    }
                                }
                            }
                            .background(
                                RoundedRectangle(cornerRadius: 25, style: .continuous)
                            )
                            .padding()
                            .shadow(color: .gray.opacity(0.2), radius: 10, x: 0, y: 5)
                        }
                       
                        HStack(spacing: 17) {
                            NavigationLink(destination: SearchView()) {
                                VStack {
                                    Image("DoctorImage")
                                        .resizable()
                                        .frame(width: 110, height: 120)
                                        .padding()
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                    
                                    Text("Book Appointment")
                                        .font(.headline)
                                        .foregroundColor(.primary)
                                        .padding(.bottom, 8)
                                        .padding(.top, -13)
                                }
                                .frame(maxWidth: .infinity)
                                .background(Color(.systemGray6))
                                .cornerRadius(15)
                            }
                            NavigationLink(destination: InstantConsultView()) {
                                VStack {
                                    Image("VideoCall")
                                        .resizable()
                                        .frame(width: 120, height: 120)
                                        .padding()
                                        .onTapGesture {
                                            showPaymentPopup = true
                                        }
                                    
                                    Text("Instant Consult")
                                        .font(.headline)
                                        .padding(.bottom, 8)
                                        .padding(.top, -13)
                                        .foregroundColor(.black)
                                }
                                .frame(maxWidth: .infinity)
                                .background(Color(.systemGray6))
                                .cornerRadius(15)
                            }
                                
                            }
                            .padding(.horizontal)
                            .padding(.vertical, 8)
                            .shadow(color: .gray.opacity(0.2), radius: 10, x: 0, y: 5)
                        
                            
                        
                        GroupBox {
                            VStack(alignment: .leading, spacing: 4) {
                                NavigationLink(destination: MedicalRecordView()) {
                                    HStack {
                                        Text("Medical Records")
                                            .font(.headline)
                                            .padding(.bottom, 3)
                                            .foregroundColor(.black)
                                        
                                        Spacer()
                                        
                                        Image(systemName: "chevron.right")
                                            .foregroundColor(.gray)
                                    }
                                    .padding()
                                }
                                
                                Divider()
                                
                                
                                NavigationLink(destination: PrescriptionsView()) {
                                    HStack {
                                        Text("Prescription")
                                            .font(.headline)
                                            .padding(.bottom, 3)
                                            .foregroundColor(.black)
                                        Spacer()
                                        Image(systemName: "chevron.right")
                                            .foregroundColor(.gray)
                                    }
                                    .padding()
                                }
                                
                                
                                
//                                NavigationLink(destination: LogInView(), isActive: $isloggedOut){
//                                    EmptyView()
//                                }
//                                Button(action: {
//                                    do {
//                                        try Auth.auth().signOut()
//                                        isloggedOut = true
//                                    }catch{
//                                        print("Error")
//                                    }
//
//                                }, label: {
//                                    Text("Sign Out")
//                                        .font(.headline)
//                                        .padding(.bottom, 3)
//                                        .padding(.top, 9)
//                                        .padding(.leading, 17)
//                                        .foregroundColor(Color("Color 1"))
//                                })
                               
                            }
                            
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 25, style: .continuous)
                                .fill(Color.gray.opacity(0.1))
                        )
                        .padding()
                        
                        .shadow(color: .gray.opacity(0.2), radius: 10, x: 0, y: 5)/*/Users/ios/Downloads/Patient-HMS 6/Patient-HMS/HomeView.swift*/
                        
                        Spacer()
                    }
                }
            }
        }
        .navigationBarHidden(true)
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Confirm Cancellation"),
                message: Text("Are you sure you want to cancel the appointment?"),
                primaryButton: .destructive(Text("Cancel")) {
                    guard var id = viewModel.newAppointements.first?.id else{return}
                                            Firestore.firestore().collection("Appointements").document(id).delete()
                    
                    isAppointmentCancelled = true
                },
                secondaryButton: .cancel()
            )
        }
        .sheet(isPresented: $isRescheduling) {
            RescheduleView(selectedDate: $appointmentDate, selectedTimeSlot: $appointmentTimeSlot, isPresented: $isRescheduling)
        }
        .sheet(isPresented: $showPaymentPopup) {
            PaymentView(isPresented: $showPaymentPopup)
        }
    }
}


struct PaymentView: View {
    @Binding var isPresented: Bool
    @State private var showPaymentConfirmation = false
    @State private var showFaceTimeScreen = false
    @State private var paymentAmount: String = "₹500"
    
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

    func fetchPaymentAmount() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.paymentAmount = "₹500"
        }
    }
}
//    var body: some View {
//        VStack(spacing: 20) {
//            Text("Payment Initiated")
//                .font(.title)
//                .padding()
//
//            FacetimeButton(address: "krushna2483@gmail.com")
//
//            Button(action: {
//                isPresented = false
//            }) {
//                Text("OK")
//                    .foregroundColor(.white)
//                    .padding()
//                    .background(Color.blue)
//                    .cornerRadius(10)
//            }
//        }
//        .padding()
//    }


struct RescheduleView: View {
    @Binding var selectedDate: Date
    @Binding var selectedTimeSlot: String?
    @Binding var isPresented: Bool
    
    @State private var newDate = Date()
    @State private var newTimeSlot: String? = nil
    
    private var dateRange: ClosedRange<Date> {
        let today = Calendar.current.startOfDay(for: Date())
        let threeDaysFromNow = Calendar.current.date(byAdding: .day, value: 3, to: today)!
        return today...threeDaysFromNow
    }
    
    private var timeSlots: [String] {
        ["09:00-10:00", "10:00-11:00", "11:00-12:00", "12:00-13:00"]
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    DatePicker(
                        "Select Date",
                        selection: $newDate,
                        in: dateRange,
                        displayedComponents: .date
                    )
                    .datePickerStyle(GraphicalDatePickerStyle())
                    .padding()

                    Text("Select Time Slot")
                        .font(.headline)
                        .padding(.top)

                    VStack(spacing: 10) {
                        ForEach(timeSlots, id: \.self) { timeSlot in
                            Text(timeSlot)
                                .foregroundColor(newTimeSlot == timeSlot ? .white : .blue)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(newTimeSlot == timeSlot ? Color.blue : Color.gray.opacity(0.1))
                                .cornerRadius(10)
                                .onTapGesture {
                                    newTimeSlot = timeSlot
                                }
                                .padding(.horizontal)
                        }
                    }
                    .padding(.vertical)

                    Spacer()
                    
                    Button(action: {
                        selectedDate = newDate
                        selectedTimeSlot = newTimeSlot
                        isPresented = false
                    }) {
                        Text("Confirm Reschedule")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.green)
                            .cornerRadius(10)
                    }
                    .padding(.bottom)
                }
                .padding()
                .navigationTitle("Reschedule Appointment")
            }
        }
    }
}

struct FacetimeButton: View {
    @Environment(\.openURL) var openURL
    var address: String
    
    var body: some View {
        Button(action: {
            makeCall(to: address.trimmingCharacters(in:.whitespacesAndNewlines))
        }) {
            Label("Make FaceTime Call", systemImage: "video.fill")
        }
        .buttonStyle(.bordered)
    }
    private func makeCall(to: String) {
        guard !to.isEmpty else {
            print("Error: Email address is empty.")
            return
        }
        
        guard let url = URL(string: "facetime://\(to)"), UIApplication.shared.canOpenURL(url) else {
            print("Error: Invalid URL or FaceTime not available for this address.")
            return
        }
        
        openURL(url)
        print("Attempting to call \(to) via FaceTime")
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
