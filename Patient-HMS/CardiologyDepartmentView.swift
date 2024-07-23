import SwiftUI

struct CardiologyDepartmentView: View {
    @Binding var appointments: [Appointment]
    var department: String
    @State private var doctors: [String] = []
    @State private var searchText = ""
    
    var filteredDoctors: [String] {
        if searchText.isEmpty {
            return doctors
        } else {
            return doctors.filter { DataController.shared.getDoc(withId: $0).name.localizedCaseInsensitiveContains(searchText) }
        }
    }

    var body: some View {
        ZStack(alignment: .bottom) {
//            Color("backgroundColor")
//                .ignoresSafeArea()
            
            VStack(spacing: 10) {
                SearchBarTwo(searchText: $searchText)
                
                List(filteredDoctors, id: \.self) { doctor in
                    DoctorRow(doctor: DataController.shared.getDoc(withId: doctor), appointments: $appointments)
                        
                }
//                .background(Color.clear)
                .listStyle(.insetGrouped)
                
                .onAppear {
                    // Retrieve doctors by department
                    self.doctors = DataController.shared.getDoctorsByDepartment(department: department)
                }
                Spacer()
            }
            
            // Overlaying wave images
//            Image("wave1")
//                .resizable()
//                .aspectRatio(contentMode: .fill)
//                .frame(height: 100)
//                .padding(.bottom, 20)
//            
//            Image("wave2")
//                .resizable()
//                .aspectRatio(contentMode: .fill)
//                .frame(height: 100)
//                .padding(.bottom, 20)
        }
        .toolbarTitleDisplayMode(.inline)
        .navigationTitle("\(department)")
    }
}

struct SearchBarTwo: View {
    @Binding var searchText: String
    
    var body: some View {
        HStack {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                TextField("Search for Doctor", text: $searchText)
                    .foregroundColor(.black)
            }
            .padding(7)
            .padding(.horizontal, 10)
            .background(Color(.systemGray4).opacity(0.5))
            .cornerRadius(8)
            .padding(.horizontal, 10)
            .padding(.top,20).frame(width: 373)
        }
    }
}
//struct CardiologyDepartmentView_Previews: PreviewProvider {
//    static var previews: some View {
//        CardiologyDepartmentView()
//    }
//}


