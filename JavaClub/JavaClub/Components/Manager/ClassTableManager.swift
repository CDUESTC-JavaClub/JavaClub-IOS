//
//  ClassTableManager.swift
//  JavaClub-iOS
//
//  Created by Roy Rao on 2021/9/14.
//

import Foundation
import SwiftyJSON
import Defaults

class ClassTableManager {
    static let shared = ClassTableManager()
    
    private init() {}
}


// MARK: Shared Methods -
extension ClassTableManager {
    
    func decode(from data: Data) -> [KAClass]? {
        var result: [KAClass] = []
        
        for _ in 0 ..< 35 {
            let tmp = KAClass(
                name: "",
                classID: "",
                teacher: "",
                locale: "",
                day: 0,
                indexSet: [],
                weekFrom: 0,
                weekTo: 0,
                form: .regular
            )
            result.append(tmp)
        }
        
        do {
            let jsonArr = (try JSON(data: data))["data"].arrayValue
            
            jsonArr.forEach { json in
                let index = ClassTableManager.shared.processIndexSet(raw: json["indexSet"].arrayObject as? [Int] ?? [])
                
                let weekSet = json["weekSet"].arrayObject as? [Int] ?? []
                let classForm = ClassTableManager.shared.processWeekSet(from: weekSet.first!)
                
                var _class = KAClass(
                    name: json["name"].stringValue,
                    classID: json["id"].stringValue,
                    teacher: json["teacher"].stringValue,
                    locale: json["local"].stringValue,
                    day: json["day"].intValue,
                    indexSet: index,
                    weekFrom: weekSet.first!,
                    weekTo: weekSet.last!,
                    form: classForm
                )
                
                if !_class.indexSet.isEmpty {
                    _class.indexSet.forEach {
                        _class.id = UUID().uuidString
                        
                        let index = ($0 - 1 >= 0 ? $0 - 1 : 0) * 7 + _class.day
                        result[index - 1] = _class
                    }
                }
            }
        } catch {
            print("DEBUG: Parse Error: \(error.localizedDescription)")
        }
        
        return result.isEmpty ? nil : result
    }
    
    func fromLocal() -> [KAClass]? {
        guard let jsonData = Defaults[.classTableJsonData] else { return nil }
        
        return decode(from: jsonData)
    }
    
    func processIndexSet(raw: [Int]) -> [Int] {
        switch raw {
        case ClassIndex.first:
            return [1]
            
        case ClassIndex.second:
            return [2]
            
        case ClassIndex.third:
            return [3]
            
        case ClassIndex.forth:
            return [4]
            
        case ClassIndex.fifth:
            return [5]
            
        case ClassIndex.morning:
            return [1, 2]
            
        case ClassIndex.afternoon:
            return [3, 4]
            
        case ClassIndex.evening:
            return [5]
            
        case ClassIndex.error:
            return []
            
        default:
            return []
        }
    }
    
    func processWeekSet(from: Int) -> ClassForm {
        if from.isMultiple(of: 2), (from + 1).isMultiple(of: 2) {
            return .even
        } else if !from.isMultiple(of: 2), !(from + 1).isMultiple(of: 2) {
            return .singular
        } else {
            return .regular
        }
    }
}


// MARK: Shared Database Methods -
//extension ClassTableManager {
//
//    /**
//     *  Initiate the table with `KAClass` items.
//     *
//     *  - Parameters:
//     *      - classItems: `KAClass` Items to save to database.
//     */
//    func initiate(with classItems: [KAClass]) {
//        clean(manifest: true)
//
//        guard let realm = try? Realm() else { return }
//
//        let realmItems = realm.objects(KAClassRealm.self).sorted(byKeyPath: "_id", ascending: true)
//
//        realmItems.forEach { realmItem in
//            if let classItem = classItems.filter({ ($0.day - 1) * 5 + $0.index == realmItem._id }).first {
//
//                do {
//                    try realm.write {
//                        realmItem.className = classItem.name
//                        realmItem.teacher = classItem.teacher
//                        realmItem.location = classItem.locale
//                        realmItem.classID = classItem.classID
//                        realmItem.day = classItem.day
//                        realmItem.index = classItem.index
//                        realmItem.weekFrom = classItem.weekFrom
//                        realmItem.weekTo = classItem.weekTo
//                        realmItem.form = classItem.form
//                    }
//                } catch {
//                    print("DEBUG: Realm Wirte Failed With Error: \(error.localizedDescription)")
//                }
//            }
//        }
//    }
//
//    /**
//     *  Retrieve `KAClass` item from the database.
//     *
//     *  - Parameters:
//     *      - key: The primary key for getting the according object.
//     */
//    func retrieve(for key: Int) -> KAClass? {
//        guard let realm = try? Realm() else { return nil }
//
//        if let realmItem = realm.object(ofType: KAClassRealm.self, forPrimaryKey: key) {
//            return KAClass(
//                name: realmItem.className,
//                classID: realmItem.classID,
//                teacher: realmItem.teacher,
//                locale: realmItem.location,
//                day: realmItem.day,
//                index: realmItem.index,
//                weekFrom: realmItem.weekFrom,
//                weekTo: realmItem.weekTo,
//                form: realmItem.form
//            )
//        }
//
//        return nil
//    }
//
//    /**
//     *  Retrieve all `KAClass` items from the database.
//     *
//     *  - Parameters:
//     *      - key: The primary key for getting the according object.
//     */
//    func retrieveAll() -> [KAClass] {
//        guard let realm = try? Realm() else { return [] }
//
//        var result: [KAClass] = []
//
//        let realmItems = realm.objects(KAClassRealm.self).sorted(byKeyPath: "_id", ascending: true)
//
//        realmItems.forEach { item in
//            result.append(
//                KAClass(
//                    name: item.className,
//                    classID: item.classID,
//                    teacher: item.teacher,
//                    locale: item.location,
//                    day: item.day,
//                    index: item.index,
//                    weekFrom: item.weekFrom,
//                    weekTo: item.weekTo,
//                    form: item.form
//                )
//            )
//        }
//
//        return result
//    }
//
//    /**
//     *  Remove classes from database.
//     *
//     *  - Parameters:
//     *      - key: The primary key for getting the according object.
//     */
//    func remove(for key: Int) {
//
//    }
//
//    /**
//     *  Remove all classes from the database and set every item empty.
//     */
//    func clean(manifest: Bool = false) {
//        guard let realm = try? Realm() else { return }
//
//        do {
//            let pendingObjects = realm.objects(KAClassRealm.self)
//
//            try realm.write {
//                realm.delete(pendingObjects)
//            }
//        } catch {
//            print("DEBUG: Realm Wirte Failed With Error: \(error.localizedDescription)")
//        }
//
//        if manifest {
//            for index in 1 ... 35 {
//                do {
//                    try realm.write {
//                        let emptyItem = KAClassRealm()
//                        emptyItem._id = index
//
//                        realm.add(emptyItem)
//                    }
//                } catch {
//                    print("DEBUG: Realm Wirte Failed With Error: \(error.localizedDescription)")
//                }
//            }
//        }
//    }
//}
