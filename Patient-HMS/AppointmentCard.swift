//
//  AppointmentCard.swift
//  Patient-HMS
//
//  Created by IOS on 13/07/24.
//

import FirebaseFirestore
import SwiftUI

class AppointmentCard : ObservableObject{
    private let db = Firestore.firestore()
    @Published var newAppointements:[Appointment] = []
    @Published var doctorDetail : [[String]] = []
//    @Published var name : String = ""
//    @Published var department : String = ""
    init(){
        db.collection("Appointements").getDocuments { [self] snapshot, error in
            if let error = error {
                print("Error fetching appointments: \(error)")
                return
            }
            else{
                guard let snapshot = snapshot?.documents else{
                    print("no data found")
                    return
                }
                for snap in snapshot{
                    let data = snap.data()
                    if data["patientId"] as? String == currentuser.id{
                        let id  = data["id"] as? String ?? ""
                        let patientId = data["patientId"] as? String ?? ""
                        let doctorID = data["doctorId"] as? String ?? ""
                        let date = data["date"] as? String ?? ""
                        let timeSlot = data["timeSlot"] as? String ?? ""
                        let isPremium = data["isPremium"] as? Bool ?? false
                        
                        var string:[String] = []
                        db.document("Doctors/\(doctorID)").getDocument { documentSnapshot,error in
                                if let error = error {
                                    print("Error fetching doctor name: \(error)")
                                    
                                }
                            else if let documentSnapshot, documentSnapshot.exists{
                                if let data = documentSnapshot.data(){
                                    let doctorName = data["name"] as? String ?? ""
                                    let doctorDepartment = data["department"] as? String ?? ""
                                    print("\(doctorName)")
                                    string.append(doctorName)
                                    string.append(doctorDepartment)
                                    self.doctorDetail.append(string)
                                }
                             }
                         }
//                        var hi = fetchDoctorName(doctorId: doctorID)
//                        name = hi.first!
//                        department = hi.last!
                            let appointment = Appointment(id: id, patientId: patientId, doctorId: doctorID, date: date, timeSlot: timeSlot, isPremium: isPremium)
                            newAppointements.append(appointment)
                        
                        print(doctorDetail)
//                            print(appointment)
                            
                        }
                    }
                    
                }
                
            }
        }
    }


private func fetchDoctorName(doctorId: String)  -> [String]{
    var string:[String] = []
    let db = Firestore.firestore()
    db.document("Doctors/\(doctorId)").getDocument { documentSnapshot,error in
            if let error = error {
                print("Error fetching doctor name: \(error)")
                
            }
        else if let documentSnapshot, documentSnapshot.exists{
            if let data = documentSnapshot.data(){
                let doctorName = data["name"] as? String ?? ""
                let doctorDepartment = data["department"] as? String ?? ""
                print("\(doctorName)")
                string.append(doctorName)
                string.append(doctorDepartment)
//
            }

            }
    }
    return string
    }

   
