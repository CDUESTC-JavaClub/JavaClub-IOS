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
            logger.warning("Parse Failed With Error:", context: error.localizedDescription)
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
