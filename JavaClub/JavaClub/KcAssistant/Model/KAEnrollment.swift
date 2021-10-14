//
//  KAEnrollment.swift
//  JavaClub-iOS
//
//  Created by Roy Rao on 2021/9/8.
//

import Foundation
import Defaults

struct KAEnrollment: Codable, DefaultsSerializable {
    
    // Enrollment Info
    var campus: String
    var degree: String
    var system: String
    var dateEnrolled: String
    var dateGraduation: String
    var department: String
    var subject: String
    var grade: String
    var direction: String
    var _class: String
    var enrollmentForm: String
    var enrollmentStatus: String
    
    // Personal Info
    var name: String
    var engName: String
    var gender: String
    var studentID: String
}


extension Encodable {
    
    var toDict: [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
    }
}
