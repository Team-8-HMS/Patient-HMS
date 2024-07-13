import SwiftUI

struct HomeView: View {
    @State private var isShowingOverlay = false
    @State private var showAlert = false
    @State private var isRescheduling = false
    @State private var isAppointmentCancelled = false
    @State private var appointmentDate = Date()
    @State private var appointmentTimeSlot: String? = "10:00 - 11:00 am"
    @State private var showPaymentPopup = false
    
    var body: some View {
        NavigationView {
            ZStack {
                // Set the background color for the whole screen
                Color("backgroundColor")
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack {
                        GroupBox {
                            if isAppointmentCancelled {
                                VStack {
                                    Text("+ No Upcoming Appointment")
                                        .font(.headline)
                                        .padding()
                                }
                                .frame(maxWidth: .infinity, minHeight: 100)
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(25)
                                .padding()
                            } else {
                                VStack(alignment: .leading, spacing: 16) {
                                    Text("Upcoming Appointment")
                                    
                                    HStack {
                                        Image(systemName: "person.crop.circle.fill")
                                            .resizable()
                                            .frame(width: 60, height: 60)
                                            .clipShape(Circle())
                                            .padding(.trailing, 8)
                                        
                                        VStack(alignment: .leading) {
                                            Text("Dr. Anjali Jaiswal, MD")
                                                .font(.headline)
                                            
                                            Text("Dermatologist")
                                                .font(.subheadline)
                                        }
                                    }
                                    .padding(.vertical, 3)
                                    
                                    HStack {
                                        HStack {
                                            Image(systemName: "clock.fill")
                                                .foregroundColor(.white)
                                            
                                            Text(appointmentDate, style: .date)
                                                .foregroundColor(.white)
                                                .font(.system(size: 11.5, weight: .bold))
                                                .lineLimit(1)
                                            Spacer()
                                            Image(systemName: "calendar")
                                                .foregroundColor(.white)
                                            Text(appointmentTimeSlot ?? "")
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
                        
                        HStack(spacing: 17) {
                            NavigationLink(destination: SearchView()) {
                                VStack {
                                    Image("DoctorImage")
                                        .resizable()
                                        .frame(width: 120, height: 120)
                                        .foregroundColor(.blue)
                                        .padding()
                                        .clipShape(RoundedRectangle(cornerRadius: 20))
                                    
                                    Text("Book Appointment")
                                        .font(.headline)
                                        .foregroundColor(.primary)
                                        .padding(.bottom, 8)
                                        .padding(.top, -13)
                                }
                                .frame(maxWidth: .infinity)
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(15)
                            }
                            
                            VStack {
                                Image("VideoCall")
                                    .resizable()
                                    .frame(width: 100, height: 120)
                                    .padding()
                                    .onTapGesture {
                                        showPaymentPopup = true
                                    }
                                
                                Text("Instant Consult")
                                    .font(.headline)
                                    .padding(.bottom, 8)
                                    .padding(.top, -13)
                            }
                            .frame(maxWidth: .infinity)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(15)
                            .shadow(color: .gray.opacity(0.2), radius: 10, x: 0, y: 5)
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 8)
                        
                        GroupBox {
                            VStack(alignment: .leading, spacing: 4) {
                                HStack {
                                    Text("Medical Records")
                                        .font(.headline)
                                        .padding(.bottom, 3)
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.gray)
                                }
                                .padding()
                                
                                Divider()
                                
                                HStack {
                                    Text("Lab Records")
                                        .font(.headline)
                                        .padding(.bottom, 3)
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.gray)
                                }
                                .padding()
                                
                                Divider()
                                
                                HStack {
                                    Text("Medical Bills")
                                        .font(.headline)
                                        .padding(.bottom, 3)
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.gray)
                                }
                                .padding()
                            }
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 25, style: .continuous)
                                .fill(Color.gray.opacity(0.1))
                        )
                        .padding()
                        .shadow(color: .gray.opacity(0.2), radius: 10, x: 0, y: 5)
                        
                        Spacer()
                    }
                    .navigationTitle("Home")
                }
            }
        }
        .navigationBarHidden(true)
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Confirm Cancellation"),
                message: Text("Are you sure you want to cancel the appointment?"),
                primaryButton: .destructive(Text("Cancel")) {
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

    var body: some View {
        VStack(spacing: 20) {
            Text("Payment Initiated")
                .font(.title)
                .padding()

            FacetimeButton(address: "krushna2483@gmail.com")

            Button(action: {
                isPresented = false
            }) {
                Text("OK")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
        }
        .padding()
    }
}

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
