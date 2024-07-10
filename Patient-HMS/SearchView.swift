//
//  SearchView.swift
//  Patient-HMS
//
//  Created by IOS on 05/07/24.
//

import SwiftUI

struct SearchView: View {
    var body: some View {
        
            ZStack {
             
                Color("backgroundColor")
                    .ignoresSafeArea()

                ScrollView {
                    VStack(alignment: .leading) {
                        SearchBar()
                            
                    

                        SectionHeader(title: "Recently Visited")
                        HorizontalScrollView(items: Array(repeating: "Dr. Rahul Verma", count: 5))
                            .padding(.top, 5)

                        SectionHeader(title: "Departments")
                        DepartmentScrollView(items: [("Cardiology", "heart_Image"), ("Dental", "Dental"), ("Neurology", "Neurology")])

                        SectionHeader(title: "Recommend Doctors")
                        HorizontalScrollView(items: Array(repeating: "Dr. Rahul Verma", count: 5))
                        
                        SectionHeader(title: "Recommend Tests")
                        HorizontalScrollView(items: Array(repeating: "Dr. Rahul Verma", count: 5))
                    }
                    .padding()
                    .padding(.top, 5)
                }
                .navigationBarTitle("Book Appointment")
            }
        }
    }

struct SearchBar: View {
    @State private var searchText = ""
    
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
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding(7)
                                .frame(width: 80, height: 80)
                                .cornerRadius(8)
                                .clipShape(Circle())
                                    .overlay(Circle().stroke(Color.black, lineWidth: 1))
                                .scaledToFit()
                                .frame(width: 50, height: 60)
                                .foregroundColor(.black)
                            
                            Text(item)
                                .font(.headline)
                                .padding([.top, .leading, .trailing], 10)
//                                .multilineTextAlignment(.center)
//                                .padding(.horizontal, 5)
//                                .padding(.top,12)
                                .foregroundColor(.black)
                            Text(item)
                                .font(.subheadline)
                                .padding([.leading, .bottom, .trailing], 9)
//                                .padding(.horizontal, 5)
//                                .padding(.top,25)
                                .foregroundColor(.black)
                        }
                        .frame(width: 160, height: 190)
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(radius: 2)
                        .padding(.vertical, 5) // Ensures consistent top and bottom padding
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
                    NavigationLink(destination: DetailView(name: item.0)) {
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
                        .padding(.vertical, 5) // Ensures consistent top and bottom padding
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
//            .navigationBarTitle(name, displayMode: .inline)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
