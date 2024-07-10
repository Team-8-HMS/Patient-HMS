//
//  DataController.swift
//  Landmark
//
//  Created by Prateek Kumar Rai on 04/07/24.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage
import SwiftUI

var currentuser: Patient = Patient(id: "", FirstName:"", LastName: "", image: "", dob: Date.now, gender: "", contactNumber: "", email: "", address: "", emergencyContact: "", upcomingAppointments: [], previousDoctors: [])

class DataController{
    
    static var shared = DataController() // Singleton instance
    let db = Firestore.firestore()
    
    private var Patients:[String:Patient] = [:]
    private var Doctors:[String:Doctor] = [:]
    private var allDoctors: [String] = []   // id
    private var allPatients : [String] = []
    private var DoctorList : [Doctor] = []
    var labTests : [String:LabTest] = [:]
    var labId: [String] = []
    

    private init() {
//        fecthDocter()
//        fetchLabTests()
        loadData()
        
        
    }
    
    
    func getDoctorsByDepartment(department: String) -> [String] {
        let filteredDoctors = DoctorList.filter { $0.department.rawValue == department }.map { $0.id }
        print("Filtered doctors for department \(department): \(filteredDoctors)")
        return filteredDoctors
    }


    
    func getCurrentUser() -> Patient{
        return currentuser
    }

    func getAllDoc() -> [String]{
        return allDoctors
    }
    func getDoc(withId id:String) -> Doctor {
        return Doctors[id]!
    }
    func setDoc(doc:Doctor){
        Doctors[doc.id] = doc
        allDoctors.append(doc.id)
        
        
    }
    
    func fecthDocter(){
        
        db.collection("Doctors").addSnapshotListener{[weak self] querySnapshot ,error in
//            var DoctorList : [Doctor] = []
            
            guard let self = self else { return }
            self.Doctors = [:]
            self.allDoctors = []
            guard let documents = querySnapshot?.documents else{
                print("No data found 1")
                return
            }
//            print(documents)
            for document in documents {
                        do {
                            let data = document.data()
                            let id =  data["id"] as? String ?? ""
                            let name = data["name"] as? String ?? ""
                            let image = data["imageURL"] as? String ?? ""
                            let department = data["department"] as? String ?? ""
                            let yearsOfExperience =  data["yearsOfExperience"] as? Int ?? nil
                            let startTime = data["entryTime"] as? String ?? ""
                            let endTime = data["exitTime"] as? String ?? ""
                            let medicalId = data["idNumber"] as? String ?? ""
                            let qualification = data["degree"] as? String ?? ""
                            let contactInfo = data["contactNo"] as? String ?? ""
                            let email = data["email"] as? String ?? ""
                            let address = data["address"] as? String ?? ""
                            let gender = data["gender"] as? String ?? ""
                            let dob = data["dob"] as? Date ?? Date.now
                            let schedule = data["workingDays"] as? [String] ?? []
                            let appointmentPrice = data["visitingFees"] as? Int ?? 0
                            let status =  data["status"] as? Bool ?? true
//                            print(document)
//                            print(data)
//                            print(name)
                            let doctor1: Doctor = Doctor(id: id, name: name, image: image, department: Departments(rawValue: department) ?? .general, yearsOfExperience: yearsOfExperience!, availableSlots: AppointmentSlot(startTime: startTime, endTime: endTime), profile: DoctorProfile(medicalId: medicalId, qualifications: qualification, contactInfo: contactInfo, email: email, address: address, gender: gender, DOB: dob, schedule: schedule, appointmentPrice: appointmentPrice), status: status)
                            //print(doctor1)
                            DoctorList.append(doctor1)
                            Doctors[doctor1.id] = doctor1
                            allDoctors.append(doctor1.id)
//                            print(allDoctors)
//                            print(Doctors)
                            //self.setDoc(doc: doctor1)
                         } 
//                catch let error {
//                            print("Error decoding document: \(error)")
//                        }
                    }
        }
    }
    
    func fetchLabTests(){
        db.collection("LabTestPrices").getDocuments{ querySnapshot , error in
            var test:LabTest
            if let error = error {
                print("Error")
            }
            else if let querySnapshot = querySnapshot{
                if querySnapshot.documents.isEmpty{
                    print("Empty Data")
                }
                else{
                    let documents = querySnapshot.documents
                    for document in documents{
                        let data = document.data()
                        if let id = data["id"] as? String,let name = data["name"] as? String,let price = data["price"] as? Int{
                            self.labTests[id] = LabTest(id: id, name: name, price: price)
//                            setLabTest(test: test)
                            self.labId.append(id)
                            
                            
                            print(self.labTests)
                        }else{
                            print("Conversion failed")
                        }
                        
                    }
                    
                }
                
            } else{
                print(" no Data Found")
            }
            
        }
    }
    private func loadData(){
//        let d1 = Doctor(id: "D1", name: "Dr. Alice Smith",image: "", department: .general, yearsOfExperience: 15, availableSlots: AppointmentSlot(startTime: Date.now, endTime: Date.now) , profile: DoctorProfile(medicalId:"ssxcs",  qualifications: "MBBS, MD", contactInfo: "alice.smith@example.com",email: "",address: "",gender: "",DOB: Date.now, schedule: [.monday,.friday,.thursday], appointmentPrice: 100), status: false)
//        
//        let d2 = Doctor(id: "D1", name: "Dr. Alice Smith",image: "", department: .general, yearsOfExperience: 15, availableSlots: AppointmentSlot(startTime: Date.now, endTime: Date.now), profile: DoctorProfile(medicalId:"ssxcs",  qualifications: "MBBS, MD", contactInfo: "alice.smith@example.com",email: "",address: "",gender: "",DOB: Date.now, schedule: [.monday,.friday,.thursday], appointmentPrice: 100), status: false)
//        
//        let d3 = Doctor(id: "D1", name: "Dr. Alice Smith",image: "", department: .general, yearsOfExperience: 15, availableSlots: AppointmentSlot(startTime: Date.now, endTime: Date.now), profile: DoctorProfile(medicalId:"ssxcs",  qualifications: "MBBS, MD", contactInfo: "alice.smith@example.com",email: "",address: "",gender: "",DOB: Date.now, schedule: [.monday,.friday,.thursday], appointmentPrice: 100), status: false)
//        let d4 = Doctor(id: "D1", name: "Dr. Alice Smith",image: "", department: .general, yearsOfExperience: 15, availableSlots: AppointmentSlot(startTime: Date.now, endTime: Date.now), profile: DoctorProfile(medicalId:"ssxcs",  qualifications: "MBBS, MD", contactInfo: "alice.smith@example.com",email: "",address: "",gender: "",DOB: Date.now, schedule: [.monday,.friday,.thursday], appointmentPrice: 100), status: false)
//        
//        let d5 = Doctor(id: "D1", name: "Dr. Alice Smith",image: "", department: .general, yearsOfExperience: 15, availableSlots: AppointmentSlot(startTime: Date.now, endTime: Date.now), profile: DoctorProfile(medicalId:"ssxcs",  qualifications: "MBBS, MD", contactInfo: "alice.smith@example.com",email: "",address: "",gender: "",DOB: Date.now, schedule: [.monday,.friday,.thursday], appointmentPrice: 100), status: false)
//        
//        let d6 = Doctor(id: "D1", name: "Dr. Alice Smith",image: "", department: .general, yearsOfExperience: 15, availableSlots: AppointmentSlot(startTime: Date.now, endTime: Date.now), profile: DoctorProfile(medicalId:"ssxcs",  qualifications: "MBBS, MD", contactInfo: "alice.smith@example.com",email: "",address: "",gender: "",DOB: Date.now, schedule: [.monday,.friday,.thursday], appointmentPrice: 100), status: false)
//        
//        let d7 = Doctor(id: "D1", name: "Dr. Alice Smith",image: "", department: .general, yearsOfExperience: 15, availableSlots: AppointmentSlot(startTime: Date.now, endTime: Date.now), profile: DoctorProfile(medicalId:"ssxcs",  qualifications: "MBBS, MD", contactInfo: "alice.smith@example.com",email: "",address: "",gender: "",DOB: Date.now, schedule: [.monday,.friday,.thursday], appointmentPrice: 100), status: false)
//        
//        let d8 = Doctor(id: "D1", name: "Dr. Alice Smith",image: "", department: .general, yearsOfExperience: 15, availableSlots: AppointmentSlot(startTime: Date.now, endTime: Date.now), profile: DoctorProfile(medicalId:"ssxcs",  qualifications: "MBBS, MD", contactInfo: "alice.smith@example.com",email: "",address: "",gender: "",DOB: Date.now, schedule: [.monday,.friday,.thursday], appointmentPrice: 100), status: false)
//        
//        let d9 = Doctor(id: "D1", name: "Dr. Alice Smith",image: "", department: .general, yearsOfExperience: 15, availableSlots: AppointmentSlot(startTime: Date.now, endTime: Date.now), profile: DoctorProfile(medicalId:"ssxcs",  qualifications: "MBBS, MD", contactInfo: "alice.smith@example.com",email: "",address: "",gender: "",DOB: Date.now, schedule: [.monday,.friday,.thursday], appointmentPrice: 100), status: false)
//        
//        let d10 = Doctor(id: "D1", name: "Dr. Alice Smith",image: "", department: .general, yearsOfExperience: 15, availableSlots: AppointmentSlot(startTime: Date.now, endTime: Date.now), profile: DoctorProfile(medicalId:"ssxcs",  qualifications: "MBBS, MD", contactInfo: "alice.smith@example.com",email: "",address: "",gender: "",DOB: Date.now, schedule: [.monday,.friday,.thursday], appointmentPrice: 100), status: false)
//    
//    
//        setDoc(doc: d1)
//        setDoc(doc: d2)
//        setDoc(doc: d3)
//        setDoc(doc: d4)
//        setDoc(doc: d5)
//        setDoc(doc: d6)
//        setDoc(doc: d7)
//        setDoc(doc: d8)
//        setDoc(doc: d9)
//        setDoc(doc: d10)
//        print(allDoctors)
//        print(Doctors)
//        
//    print(allDoctors)
//    print(Doctors)
    }
        
    
}




