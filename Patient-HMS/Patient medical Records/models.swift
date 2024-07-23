//
//  models.swift
//  Patient-HMS
//
//  Created by Dhairya bhardwaj on 15/07/24.
//

import Foundation
import SwiftUI
import FirebaseFirestore
struct MedicalRecord: Identifiable {
    var id: String
    var patientID: String
    var images: [String]
    var familyMember: String
    var fileName: String
    var date: Date
    var type: String

    // Initialize from Firestore document
    init(id: String, data: [String: Any]) {
        self.id = id
        self.patientID = data["patientID"] as? String ?? ""
        self.images = data["images"] as? [String] ?? []
        self.familyMember = data["familyMember"] as? String ?? ""
        self.fileName = data["fileName"] as? String ?? ""
        self.date = (data["date"] as? Timestamp)?.dateValue() ?? Date()
        self.type = data["type"] as? String ?? ""
    }
}

//struct MedicalRecord {
//    var id: String
//    var type: RecordType
//    var date: Date
//    var details: String
//    var attachments: [Attachment]
//}
//
//enum RecordType {
//    case labReport
//    case bill
//    case prescription
//}
