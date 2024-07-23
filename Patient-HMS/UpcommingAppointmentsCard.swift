//
//  UpcommingAppointmentsCard.swift
//  Patient-HMS
//
//  Created by IOS on 17/07/24.
//

import Foundation
import SwiftUI
import Firebase

struct UpcomingAppointmentCardView: View {
    @StateObject var viewModel = AppointmentCard()
    @Binding var isShowingOverlay: Bool
    @Binding var showAlert: Bool
    @Binding var isRescheduling: Bool
    @Binding var isAppointmentCancelled: Bool
    @Binding var appointmentDate: Date
    @Binding var appointmentTimeSlot: String?
    
    var body: some View {
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
    }
}

struct UpcomingAppointmentCardView_Previews: PreviewProvider {
    static var previews: some View {
        UpcomingAppointmentCardView(
            isShowingOverlay: .constant(false),
            showAlert: .constant(false),
            isRescheduling: .constant(false),
            isAppointmentCancelled: .constant(false),
            appointmentDate: .constant(Date()),
            appointmentTimeSlot: .constant("10:00 - 11:00 am")
        )
    }
}
