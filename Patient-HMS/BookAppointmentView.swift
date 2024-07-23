import SwiftUI

struct SearchView: View {
    @State private var searchText = ""
    @State private var showAlert = false
    @State private var showSecondAlert = false
    @State private var selectedLabTestName: String = ""
    @State private var selectedLabTestPrice: Int = 0
    
    let doctors = ["Dr. Rahul Verma", "Dr. Smith", "Dr. John Doe"]
    
    let departments = [("General", "General_Physician"),("Cardiology", "heart_Image"), ("Neurology", "Neurology"),("Pediatrics", "Pediatrics"),("Dermatology", "dermatology"),("Ophthalmology", "Eye")]
    
    var filteredDoctors: [String] {
        if searchText.isEmpty {
            return doctors
        } else {
            return doctors.filter { $0.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var filteredDepartments: [(String, String)] {
        if searchText.isEmpty {
            return departments
        } else {
            return departments.filter { $0.0.localizedCaseInsensitiveContains(searchText) }
        }
    }

    var body: some View {
        ZStack {
            Image("blob4")
                .aspectRatio(contentMode: .fit)
                .frame(width: UIScreen.main.bounds.width, height: 300)
                .offset(x: UIScreen.main.bounds.width / 1.4, y: -UIScreen.main.bounds.height / 10)
            
//            Image("blob5")
//                .aspectRatio(contentMode: .fill)
//                .frame(width: UIScreen.main.bounds.width, height: 300)
//                .offset(x: UIScreen.main.bounds.width / 35, y: UIScreen.main.bounds.height / 2)

            ScrollView {
                
                    SearchBar(searchText: $searchText)
                    
                    if !searchText.isEmpty {
                        SectionHeader(title: "Search Results")
                        if filteredDoctors.isEmpty && filteredDepartments.isEmpty {
                            Text("No results found")
                                .padding()
                        } else {
                            if !filteredDoctors.isEmpty {
                                SectionHeader(title: "Doctors")
                                HorizontalScrollView(items: filteredDoctors)
                                    .padding(.top, 5)
                            }
                            if !filteredDepartments.isEmpty {
                                SectionHeader(title: "Departments")
                                    
                                DepartmentScrollView(items: filteredDepartments)
                                
                                
                            }
                        }
                    } else {
                        SectionHeader(title: "Departments")
                            .padding(.leading, 20)
                            .padding(.top, 20)
                        DepartmentScrollView(items: departments)
                        
                        
                        SectionHeader(title: "Lab tests")
                            .padding(.leading, 20)
                        HorizontalRowView(items: DataController.shared.labId, selectedLabTestName: $selectedLabTestName, selectedLabTestPrice: $selectedLabTestPrice) {
                            // Toggle showAlert to true
                            showAlert.toggle()
                        }
                        .alert(isPresented: $showAlert) {
                            Alert(
                                title: Text("Confirm Booking"),
                                message: Text("Are you sure you want to book \(selectedLabTestName) for \(selectedLabTestPrice) price?"),
                                primaryButton: .default(Text("Yes")) {
                                    // Handle booking confirmation logic here
                                    print("Booking confirmed for \(selectedLabTestName) at \(selectedLabTestPrice)")
                                },
                                secondaryButton: .cancel(Text("No"))
                            )
                        }
                       
                        
                    }
                
            }
            
            .padding(.horizontal, 0) // side hiding issue solved
            
            .navigationBarTitle("Book Appointment")
            .toolbarTitleDisplayMode(.inline)
            
            
        }
        
    }
    
    
}

struct SearchBar: View {
    @Binding var searchText: String
    
    var body: some View {
//        HStack {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                TextField("Search for Doctor or Department", text: $searchText)
                    .foregroundColor(.black)
            }
            .padding(10)
            .padding(.horizontal, 10)
            .background(Color(.systemGray4).opacity(0.5))
            .cornerRadius(10)
            .frame(width: 361, height: 35)
            
//        }
        .padding(.top, 30) // Adjust top padding to shift the search bar down
                .padding(.horizontal)
    }
    
    
}

struct SectionHeader: View {
    var title: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.headline)
                
            Spacer()
        }
        .padding(.vertical, 10)
    }
}

struct HorizontalScrollView: View {
    var items: [String]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(items, id: \.self) { item in
                    
                    Text(item)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(radius: 2)
                }
            }
            .padding(.horizontal, 0)
        }
        .padding(.vertical)
    }
}

struct DepartmentScrollView: View {
    var items: [(String, String)]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 15) {
                ForEach(items, id: \.0) { item in
                    NavigationLink(destination: CardiologyDepartmentView(appointments: .constant([]), department: item.0)) {
                        VStack {
                            Image(item.1)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50, height: 60)
                                .foregroundColor(.black)
                            Text(item.0)
                                .font(.subheadline)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 10)
                                .padding(.top, 1)
                                .foregroundColor(.black)
                        }
                        .frame(width: 120, height: 120)
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(radius: 2)
                        .padding(.vertical, 10)
                    }
                }
            }
            .padding(.horizontal, 15)
        }
        .padding(.vertical, 0)
    }
        
}

struct HorizontalRowView: View {
    var items: [String]
    @Binding var selectedLabTestName: String
    @Binding var selectedLabTestPrice: Int
    var onTap: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            ForEach(items, id: \.self) { item in
                Button(action: {
                    if let labTest = DataController.shared.labTests[item] {
                        selectedLabTestName = labTest.name
                        selectedLabTestPrice = Int(Double(labTest.price))
                        onTap() // Call onTap closure to toggle showAlert
                    }
                }) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text(DataController.shared.labTests[item]?.name ?? "")
                                .font(.subheadline)
                                .foregroundColor(.black)
                            Text("\(DataController.shared.labTests[item]?.price ?? 0)")
                                .font(.subheadline)
                                .foregroundColor(.black)
                        }
                        Spacer()
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 2)
                    .padding(.vertical, 5)
                    .padding(.leading, 12)
                    .padding(.trailing, 12)
                    .padding(.horizontal, 12)
                }
            }
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}

