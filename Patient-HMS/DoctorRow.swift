import SwiftUI
import FirebaseStorage

struct DoctorRow: View {
    let doctor: Doctor
    @Binding var appointments: [Appointment]

    var body: some View {
        NavigationLink(destination: DoctorDetailView(doctor: doctor)) {
            HStack {
                AsyncImage(url: URL(string: doctor.image)){image in
                                    image
                                        .resizable()
                                        .frame(width: 65,height: 65)
                                        .clipShape(Circle())
                                        .overlay(Circle().stroke(Color.black,lineWidth: 1))
                                }placeholder: {
                                    ProgressView()
                                        .frame(width: 65,height: 60)
                                        .clipShape(Circle())
                                        .overlay(Circle().stroke(Color.black,lineWidth: 1))
                                }

                VStack(alignment: .leading, spacing: 10) {
                    Text(doctor.name)
                        .font(.headline)
                    Text(doctor.department.rawValue)
                        .font(.caption)
                    Text("\(doctor.yearsOfExperience)")
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)
                }

                Spacer()

                Text("Book Visit")
                    .font(.caption)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 10)
                    .background(Color.CustomRed)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding(.vertical, 4)
        }
    }
}

