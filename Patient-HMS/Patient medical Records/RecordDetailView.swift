//
//  RecordDetailView.swift
//  Patient-HMS
//
//  Created by Dhairya bhardwaj on 15/07/24.
//


import SwiftUI

struct RecordDetailView: View {
    var record: MedicalRecord
    
    var body: some View {
        VStack(alignment: .leading) {
            ScrollView(.horizontal) {
                HStack {
                    ForEach(record.images, id: \.self) { imageUrl in
                        AsyncImageLoader(url: imageUrl)
                            .frame(width: 100, height: 100)
                            .cornerRadius(10)
                    }
                }
            }
            .padding(.bottom, 20)
            
            Text("Family Member: \(record.familyMember)")
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(5)
            
            
            Text("File Name: \(record.fileName)")
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(5)
            
            Text("Record Date: \(record.date, style: .date)")
                .padding(.bottom,10)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(5)
            
            Text("Record Type: \(record.type)")
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(5)
            
            Spacer()
        }
        
        .padding()
        .navigationTitle("Record Details")
    }
}
