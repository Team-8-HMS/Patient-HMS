import SwiftUI
import FirebaseFirestore
import FirebaseStorage


struct DoctorDetailView: View {
    
    
    @State private var selectedTimeSlot: String = ""
    @State private var selectedDate: Date = Date()
    @State private var patientName: String = ""
    @State private var patientAge: String = ""

    let doctor: Doctor
    
    
    

    var dateRange: ClosedRange<Date> {
        let today = Calendar.current.startOfDay(for: Date())
        let sevenDaysFromNow = Calendar.current.date(byAdding: .day, value: 7, to: today)!
        return today...sevenDaysFromNow
    }

    var body: some View {
        ScrollView {
            Color("backgroundColor")
                .ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 20) {
                DoctorHeaderView(doctor: doctor)
                DoctorInfoView(doctor: doctor)
                AppointmentBookingView(
                    doctor: doctor,
                    selectedTimeSlot: $selectedTimeSlot,
                    selectedDate: $selectedDate,
                    patientName: $patientName,
                    patientAge: $patientAge
                )
            }
        }
        .navigationTitle(doctor.name)
        .navigationBarTitleDisplayMode(.inline)
        .background(Color.gray.opacity(0.1))
    }
}

struct DoctorHeaderView: View {
    let doctor: Doctor

    var body: some View {
        HStack {
            
                AsyncImage(url: URL(string: doctor.image)){image in
                image
                        .resizable()
                        .frame(width: 100,height: 100)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.black,lineWidth: 1))
                } placeholder: {
                    ProgressView()
                        .frame(width: 100,height: 100)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.black,lineWidth: 1))
                }
                
            
            VStack(alignment: .leading) {
                Text(doctor.name)
                    .font(.title)
                    .bold()
                Text(doctor.department.rawValue)
                    .font(.headline)
                    .foregroundColor(.secondary)
                        
                }
        }
        .padding()
    }
}

struct DoctorInfoView: View {
    let doctor: Doctor

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                InfoRow(label: "Experience:", value: "\(doctor.yearsOfExperience)")
                InfoRow(label: "Certification:", value: doctor.profile.qualifications)
                InfoRow(label: "Consultation Fee:", value: "₹ \(doctor.profile.appointmentPrice)")
                InfoRow(label: "Timings:", value: "\(doctor.availableSlots.startTime) - \(doctor.availableSlots.endTime)")
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.white)
                    .shadow(color: .gray.opacity(0.4), radius: 5, x: 0, y: 5)
            )
            .padding(.horizontal, 14)
        }
        .padding(.horizontal, 14)
    }
}


struct InfoRow: View {
    let label: String
    let value: String

    var body: some View {
        HStack {
            Text(label)
                .fontWeight(.medium)
            Spacer()
            Text(value)
        }
    }
}

struct SectionTitleView: View {
    let title: String

    var body: some View {
        Text(title)
            .font(.headline)
            .padding(.vertical, 8)
    }
}

struct AppointmentBookingView: View {
    let doctor: Doctor
    @Binding var selectedTimeSlot: String
    @Binding var selectedDate: Date
    @Binding var patientName: String
    @Binding var patientAge: String
//    @Binding var appointments: [Appointment]

    var dateRange: ClosedRange<Date> {
        let today = Calendar.current.startOfDay(for: Date())
        let sevenDaysFromNow = Calendar.current.date(byAdding: .day, value: 7, to: today)!
        return today...sevenDaysFromNow
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            SectionTitleView(title: "Book Appointment").frame()
           
                .font(.headline)
                .padding()
            
                .padding(.top, -24)
            
            DatePickerView(selectedDate: $selectedDate)
            
            TimeSlotPickerView(doctor: doctor, selectedTimeSlot: $selectedTimeSlot)
            
            //PatientInfoView(patientName: $patientName, patientAge: $patientAge)
            
            BookButtonView(
                doctor: doctor,
                selectedDate: $selectedDate,
                selectedTimeSlot: $selectedTimeSlot,
                patientName: $patientName,
                patientAge: $patientAge
//                appointments: $appointments
            )
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white)
                .shadow(color: .gray.opacity(0.4), radius: 5, x: 0, y: 5)
        )
        
//        .padding(.horizontal)
    }
}

struct DatePickerView: View {
    @Binding var selectedDate: Date
    var dateRange: ClosedRange<Date> {
        let today = Calendar.current.startOfDay(for: Date())
        let sevenDaysFromNow = Calendar.current.date(byAdding: .day, value: 7, to: today)!
        return today...sevenDaysFromNow
    }

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Select Date")
                
                    .font(.headline)
                    .padding(.top, -10)

                DatePicker("", selection: $selectedDate, in: dateRange, displayedComponents: .date)
                    .datePickerStyle(.compact)
                    .padding(.trailing)
                    
                
                
            }
            .padding()
        }
    }
}


//struct DatePickerView: View {
//    @Binding var selectedDate: Date
//    var dateRange: ClosedRange<Date> {
//        let today = Calendar.current.startOfDay(for: Date())
//        let sevenDaysFromNow = Calendar.current.date(byAdding: .day, value: 7, to: today)!
//        return today...sevenDaysFromNow
//    }
//
//    var body: some View {
//        DatePicker("Select Date", selection: $selectedDate, in: dateRange, displayedComponents: .date)
//            .datePickerStyle(GraphicalDatePickerStyle())
//            .padding()
//    }
//}



struct TimeSlotPickerView: View {
    let doctor: Doctor
    @Binding var selectedTimeSlot: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Select Time Slot")
                .font(.headline)
                .padding()
            TimeslotGridView(selectedTimeSlot: $selectedTimeSlot)
        }
    }
}



struct TimeslotGridView: View {
    let times = [
        "09:00-10:00", "10:00-11:00", "11:00-12:00",
        "12:00-13:00"
    ]
    let columns = [GridItem(.flexible()),
                       GridItem(.flexible()),
                       GridItem(.flexible())]
    
    @Binding var selectedTimeSlot: String  // Binding for selectedTimeSlot
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 4) {
                ForEach(times, id: \.self) { time in
                    TimeSlotView(time: time, isSelected: Binding(get: {
                        selectedTimeSlot == time
                    }, set: { newValue in
                        if newValue {
                            selectedTimeSlot = time
                        } else {
                            selectedTimeSlot = ""
                        }
                    }))
                }
            }
            
        }
    }
}



struct TimeSlotView: View {
    var time: String
    @Binding var isSelected: Bool  // Add binding for isSelected
    
    var body: some View {
        Button(action: {
            isSelected.toggle()  // Toggle isSelected when the button is tapped
        }) {
            Text(time)
                .frame(width: 110, height: 50) // Adjust as needed
                .background(isSelected ? Color("Color 1") : Color.white)
                .foregroundColor(isSelected ? .white : .black)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.black, lineWidth: isSelected ? 2 : 1)
                )
//                .shadow(radius: 2)
                .padding()
        }
    }
}

struct BookButtonView: View {
    let doctor: Doctor
    @Binding var selectedDate: Date
    @Binding var selectedTimeSlot: String
    @Binding var patientName: String
    @Binding var patientAge: String

    var body: some View {
        VStack {
            Button(action: {
                let appointmentDetails = "Your appointment with \(doctor.name) on \(selectedDate.formatted) at \(selectedTimeSlot) has been scheduled."
                print(appointmentDetails)

                let alert = UIAlertController(
                    title: "Appointment Scheduled",
                    message: "Your appointment with \(doctor.name) on \(selectedDate.formatted) at \(selectedTimeSlot) has been scheduled.",
                    preferredStyle: .alert
                )

                let newappointment = Appointment(id: "\(UUID())", patientId: currentuser.id, doctorId: doctor.id, date: selectedDate.formatted, timeSlot: selectedTimeSlot, isPremium: false)
                let newAppointmentData = newappointment.toDictionary()
                let db = Firestore.firestore()
                db.collection("Appointements").document("\(newappointment.id)").setData(newAppointmentData)

                selectedTimeSlot = ""
                patientName = ""
                patientAge = ""

                alert.addAction(UIAlertAction(title: "OK", style: .default))
                UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true, completion: nil)
            }) {
                Text("Book Now")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(width: UIScreen.main.bounds.width - 50, height: 50)
                    .background(Color("Color 1"))
                    .cornerRadius(10)
                    .padding(.horizontal)
            }
            .padding(.top)
        }
    }
}



//ForEach(doctor.availableSlots, id: \.self) { slot in
//                    Text("\(slot)")
//                        .font(.system(size: 14))
//                        .padding()
//                        .frame(width: 100, height: 50)
//                        .background(selectedTimeSlot == slot ? Color.CustomRed : Color.gray)
//                        .foregroundColor(.white)
//                        .cornerRadius(10)
//                        .onTapGesture {
//                            selectedTimeSlot = slot
//                        }
//                }
//func divideIntoOneHourSlots(appointmentSlot: AppointmentSlot) -> [AppointmentSlot] {
//    var slots: [AppointmentSlot] = []
//
//    let calendar = Calendar.current
//    var currentStartTime = appointmentSlot.startTime
//
//    while currentStartTime < appointmentSlot.endTime {
//        let currentEndTime = calendar.date(byAdding: .hour, value: 1, to: currentStartTime) ?? currentStartTime
//
//        if currentEndTime > appointmentSlot.endTime {
//            slots.append(AppointmentSlot(startTime: currentStartTime, endTime: appointmentSlot.endTime))
//        } else {
//            slots.append(AppointmentSlot(startTime: currentStartTime, endTime: currentEndTime))
//        }
//
//        currentStartTime = currentEndTime
//    }
//
//    return slots
//}
//
//
//struct PatientInfoView: View {
//    @Binding var patientName: String
//    @Binding var patientAge: String
//
//    var body: some View {
//        VStack(alignment: .leading) {
//            TextField("Enter Your Name", text: $patientName)
//                .textFieldStyle(RoundedBorderTextFieldStyle())
//
//            TextField("Enter Your Age", text: $patientAge)
//                .textFieldStyle(RoundedBorderTextFieldStyle())
//                .keyboardType(.numberPad)
//        }
//        .padding()
//    }
//}
//
//
//
//struct DoctorDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        DoctorDetailView(doctor: )
//    }
//}
