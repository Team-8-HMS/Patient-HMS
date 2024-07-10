//import SwiftUI
//
//struct CardiologyDepartmentView: View {
//    @Binding var appointments: [Appointment]
//    let doctors = DataController.shared.getAllDoc()
//    
//    
////
//    
//    var body: some View {
//        VStack(spacing: 0) {
//            List(doctors,id: \.self) { doctor in
//                DoctorRow(doctor: DataController.shared.getDoc(withId: doctor), appointments: $appointments)
//            }
//            .listStyle(.insetGrouped)
//            
//        }
//        .toolbarTitleDisplayMode(.inline)
//    }
//}
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
        VStack(spacing: 0) {
            SearchBarTwo(searchText: $searchText)
               
            
            List(filteredDoctors, id: \.self) { doctor in
                DoctorRow(doctor: DataController.shared.getDoc(withId: doctor), appointments: $appointments)
            }
            .listStyle(.insetGrouped)
            .onAppear {
                // Retrieve doctors by department
                self.doctors = DataController.shared.getDoctorsByDepartment(department: department)
                
            }
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
            .padding(.top,20).frame(width: 373)        }
    }
}




