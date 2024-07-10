//
//  BookAppointmentView.swift
//  Patient-HMS
//
//  Created by IOS on 05/07/24.
//

import SwiftUI

struct SearchView: View {
    @State private var searchText = ""
    let doctors = ["Dr. Rahul Verma", "Dr. Smith", "Dr. John Doe"]
    
   
    let departments = [("General", "General_Physician"),("Cardiology", "heart_Image"), ("Nurology", "Neurology"),("Pediatrics", "Pediatrics"),("Dermatology", "Dermatology"),("Ophthalmology", "Eye")]
    
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
//            Color("backgroundColor")
//                .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading) {
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
                        SectionHeader(title: "Recently Visited")
//                        HorizontalScrollView(items: Array(repeating: "Dr. Rahul Verma", count: 5))
//                            .padding(.top, 5)

                        SectionHeader(title: "Departments")
                        DepartmentScrollView(items: departments)

                        SectionHeader(title: "Recommend Doctors")
//                        HorizontalScrollView(items: Array(repeating: "Dr. Rahul Verma", count: 5))
                        
                        SectionHeader(title: "Recommend Tests")
                        HorizontalScrollView(items: DataController.shared.labId)
                    }
                }
                .padding()
                .padding(.top, 5)
            }
            .navigationBarTitle("Book Appointment")
            .toolbarTitleDisplayMode(.inline)
        }
    }
}

struct SearchBar: View {
    @Binding var searchText: String
    
    var body: some View {
        HStack {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                TextField("Search for Doctor or Department", text: $searchText)
                    .foregroundColor(.black)
            }
            .padding(7)
            .padding(.horizontal, 10)
            .background(Color(.systemGray4).opacity(0.5))
            .cornerRadius(8)
            .padding(.horizontal, 10)
        }
    }
}

struct SectionHeader: View {
    var title: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.headline)
            Spacer()
            NavigationLink(destination: Text("See All")) {
                Text("See All")
                    .foregroundColor(Color("brandPrimary"))
            }
        }
        .padding(.vertical, 5)
    }
}

struct HorizontalScrollView: View {
    var items: [String]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 15) {
                ForEach(items, id: \.self) { item in
                    NavigationLink(destination: DetailView(name: item)) {
                        VStack {
                            Image(item)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50, height: 60)
                                .foregroundColor(.black)
                            
                            Text(DataController.shared.labTests[item]!.name)
                                .font(.headline)
                                .padding([.top, .leading, .trailing], 10)
                                .foregroundColor(.black)
                            
                            Text("\(DataController.shared.labTests[item]!.price)")
                                .font(.subheadline)
                                .padding([.leading, .bottom, .trailing], 9)
                                .foregroundColor(.black)
                        }
                        .frame(width: 160, height: 190)
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(radius: 2)
                        .padding(.vertical, 5)
                    }
                }
            }
            .padding(.horizontal)
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
                                .padding(.horizontal, 5)
                                .padding(.top, 1)
                                .foregroundColor(.black)
                        }
                        .frame(width: 120, height: 120)
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(radius: 2)
                        .padding(.vertical, 5)
                    }
                }
            }
            .padding(.horizontal)
        }
        .padding(.vertical)
    }
}

struct DetailView: View {
    var name: String
    
    var body: some View {
        Text("Details for \(name)")
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
