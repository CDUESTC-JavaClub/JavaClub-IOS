//
//  KAClassRealm.swift
//  JavaClub
//
//  Created by Roy on 2021/10/15.
//

import Foundation
import RealmSwift

class KAClassRealm: Object {
    @Persisted(primaryKey: true) var _id: Int
    @Persisted var classID = ""
    @Persisted var className: String = ""
    @Persisted var day: Int = 0
    @Persisted var location: String = ""
    @Persisted var teacher: String = ""
    @Persisted var index: Int = 0
    @Persisted var weekFrom: Int = 0
    @Persisted var weekTo: Int = 0
    @Persisted var form: ClassForm = .regular
}
