import SwiftUI
import Combine

struct SearchResultsView: View {
    @Binding var searchText: String
    @State private var internalSearchText: String = ""
    @State private var searchResults: [String] = []
    @State private var searchCancellable: AnyCancellable?
    
    let doctors = ["Dr. Rahul Verma", "Dr. Smith", "Dr. John Doe"]
    let departments = [("General", "General_Physician"),("Cardiology", "heart_Image"), ("Nurology", "Neurology"),("Pediatrics", "Pediatrics"),("Dermatology", "Dermatology"),("Ophthalmology", "Eye")]
    
    var body: some View {
        VStack {
            SearchBar(searchText: $internalSearchText)
                .padding(.horizontal)
                .padding(.top)
            
            if internalSearchText.isEmpty {
                Text("Enter search term")
                    .foregroundColor(.gray)
                    .padding()
            } else if searchResults.isEmpty {
                Text("No results found")
                    .foregroundColor(.gray)
                    .padding()
            } else {
                List(searchResults, id: \.self) { result in
                    Text(result)
                }
            }
            
            Spacer()
        }
        .navigationBarTitle("Search", displayMode: .inline)
        .onAppear {
            internalSearchText = searchText
//            setupSearchThrottling()
        }
        .onChange(of: internalSearchText) { newValue in
            searchText = newValue
        }
    }
    
//    func setupSearchThrottling() {
//        searchCancellable = $internalSearchText
//            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
//            .removeDuplicates()
//            .sink { searchText in
//                performSearch(query: searchText)
//            }
//    }
    
    func performSearch(query: String) {
        let doctorResults = doctors.filter { $0.localizedCaseInsensitiveContains(query) }
        let departmentResults = departments.filter { $0.0.localizedCaseInsensitiveContains(query) }.map { $0.0 }
        searchResults = doctorResults + departmentResults
    }
}

struct SearchResultsView_Previews: PreviewProvider {
    static var previews: some View {
        SearchResultsView(searchText: .constant(""))
    }
}
