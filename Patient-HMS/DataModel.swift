import Foundation
struct Patient {
    var id :String
    var firstname: String
    var lastname:String
    var imageURL:String
    var dob: Date
    var gender: String
    var contactNumber: String
    var email: String
    var address: String
    var emergencyContact: String
    var upcomingAppointments: [Appointment]
//    var medicalRecords: [MedicalRecord]
//    var reviews: [Review]
//    var followUps: [FollowUp]
    var previousDoctors: [String]
    
    
    
    
    func toDictionary() -> [String: Any] {
        var dict: [String: Any] = [
            "id":id,
            "firstname": firstname,
            "lastname":lastname,
            "imageURL":imageURL,
             "dob": dob,
             "gender": gender,
             "contactNumber": contactNumber,
            "email": email,
             "address": address,
             "emergencyContact": emergencyContact,
            "upcomingAppointments": upcomingAppointments
        ]
        return dict
    }
}
struct LivePrescriptions:Identifiable{
    var id :String
    var image:String?
}

struct DoctorProfile :Decodable{
    var medicalId: String
    var qualifications: String //degree
    var contactInfo: String
    var email: String
    var address:String
    var gender:String
    var DOB:Date
    var schedule: [String]
    var appointmentPrice: Int
}

struct Doctor : Decodable{
    var id: String
    var name: String
    var image :String
    var department: Departments
    var yearsOfExperience: Int
    var availableSlots: AppointmentSlot
    var profile: DoctorProfile
    var status :Bool
}

enum Departments : String,Decodable {
    case general = "General",cardiology = "Cardiology",nurology = "Nurology",pediatrics = "Pediatrics",dermatology = "Dermatology",ophthalmology = "Ophthalmology"
}

struct Appointment {
    var id: String
    var patientId: String
    var doctorId: String
    var date: String
    var timeSlot: String
//    var status: AppointmentStatus
    var isPremium: Bool
//    var paymentStatus: PaymentStatus
    func toDictionary() -> [String: Any]{
        var dict:[String:Any] = ["id":id,"patientId":patientId,"doctorId":doctorId,"date":date,"timeSlot":timeSlot,"isPremium":isPremium]
        return dict
    }
}

struct AppointmentSlot : Decodable,Hashable{
    var startTime: String
    var endTime: String
}

enum AppointmentStatus {
    case confirmed
    case cancelled
    case rescheduled
    case pendingPayment
}

enum PaymentStatus {
    case paid
    case unpaid
}

enum Days : String,Decodable{
    case monday = "Monday",tuesday = "Tuesday",wednesday = "Wednesday",thursday = "Thusday",friday = "Friday",saturday = "Saturday",sunday = "Sunday"
}


struct LabTest{
    var id: String
    var name : String
    var price: Int
}


//
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
//
//struct Attachment {
//    var id: String
//    var fileName: String
//    var fileURL: URL
//}
//
//struct Review {
//    var patientId: String
//    var doctorId: String
//    var rating: Double
//    var comment: String
//    var date: Date
//}
//
//struct FollowUp {
//    var id: String
//    var appointmentId: String
//    var date: Date
//    var timeSlot: AppointmentSlot
//    var status: FollowUpStatus
//}
//
//enum FollowUpStatus {
//    case scheduled
//    case completed
//    case missed
//}
//
//struct SOSAlert {
//    var id: String
//    var patientId: String
//    var time: Date
//    var status: SOSStatus
//    var vitals: [Vital]
//}
//
//enum SOSStatus {
//    case initiated
//    case acknowledged
//    case resolved
//}
//
//struct Vital {
//    var type: VitalType
//    var value: String
//    var unit: String
//}
//
//enum VitalType {
//    case heartRate
//    case bloodPressure
//    case temperature
//}
    


