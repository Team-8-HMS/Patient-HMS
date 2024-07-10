import SwiftUI

//struct ScheduledAppointmentView: View {
//    let appointment: Appointment
//
//    var body: some View {
//        VStack(alignment: .leading, spacing: 8) {
//            Text("Appointment with \(appointment.doctor.name)")
//                .font(.headline)
//            Text("Date: \(formattedDate)")
//                .font(.subheadline)
//            Text("Time: \(appointment.timeSlot)")
//                .font(.subheadline)
//            Text("Patient: \(appointment.patientName), Age: \(appointment.patientAge)")
//                .font(.subheadline)
//                .foregroundColor(.secondary)
//        }
//        .padding()
//        .background(Color.gray.opacity(0.1))
//        .cornerRadius(10)
//    }
//
//    private var formattedDate: String {
//        let formatter = DateFormatter()
//        formatter.dateStyle = .medium
//        return formatter.string(from: appointment.date)
//    }
//}
