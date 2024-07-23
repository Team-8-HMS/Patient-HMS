//
//  MedicalRecordsView.swift
//  Patient-HMS
//
//  Created by Dhairya bhardwaj on 15/07/24.
//


import SwiftUI
import FirebaseFirestore
import Firebase
import FirebaseStorage

struct MedicalRecordView: View {
    @State private var records: [MedicalRecord] = []
    @State private var isAddingRecord = false

    var body: some View {
        VStack {
            if records.isEmpty {
                Text("No records available.")
                    .foregroundColor(.gray)
                    .padding()
            } else {
                List(records) { record in
                    NavigationLink(destination: MedicalRecordDetailView(record: record)) {
                        VStack(alignment: .leading) {
                            HStack {
                                Image(systemName: "doc.text.fill")
                                    .foregroundColor(Color("Color 1"))
                                    .font(.title)
                                    .padding(.trailing, 10)
                                VStack(alignment: .leading) {
                                    Text(record.fileName)
                                        .font(.headline)
                                    HStack {
                                        Text(record.type)
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                        Spacer()
                                        Text(record.date, style: .date)
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                    }
                                }
                            }
                            .padding(.vertical, 8)
                        }
                    }
                }
                .listStyle(PlainListStyle())
            }
        }
        .onAppear(perform: fetchRecords)
        .navigationTitle("Medical Records")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    isAddingRecord = true
                }) {
                    Image(systemName: "plus")
                        .font(.title2)
                }
            }
        }
        .sheet(isPresented: $isAddingRecord) {
            AddRecordDetailsView(records: $records)
        }
    }

    private func fetchRecords() {
        let db = Firestore.firestore()
        db.collection("medicalRecords")
            .whereField("patientID", isEqualTo: currentuser.id)
            .getDocuments { (snapshot, error) in
                if let error = error {
                    print("Error fetching records: \(error.localizedDescription)")
                    return
                }
                guard let snapshot = snapshot else {
                    print("No records found")
                    return
                }
                self.records = snapshot.documents.compactMap { document in
                    MedicalRecord(id: document.documentID, data: document.data())
                }
                print("Fetched records: \(self.records)")
            }
    }
}

