//
//  BAAccountManager.swift
//  JavaClub
//
//  Created by Roy on 2021/11/1.
//

import Foundation
import Alamofire
import SwiftyJSON
import Defaults

enum EventStatus: Int {
    case all = 0
    case signing = 4
    case stopped = 5
    case active = 7
    case end = 8
}

enum EventType : Int {
    case bx = 1
    case dx = 2
    case jm = 3
    case md = 4
}

class BAAccountManager {
    static let shared = BAAccountManager()
    let apiLink = "http://byjh.cduestc.cn"   // http://byjh.cduestc.cn:1356 是外网端口，但是目前失效，可能学校以后会重新启用
    
    private init() {}
}


// MARK: Shared Methods -
extension BAAccountManager {
    
    /**
     *  务必在使用前进行登陆，才能使用其他功能
     *
     *  - Parameters:
     *      - info: 登录的账号密码信息
     *      - completion: 结果回调 `BAAccount`
     */
    func login(info: BALoginInfo, _ completion: @escaping (Result<BAAccount, JCError>) -> Void) {
        let parameters = [
            "student_id": info.id,
            "password": info.password
        ]
        
        AFTask("/Api/Token/login", parameters: parameters) { [weak self] result in
            if let result = try? result.get() {
                if result["status"].intValue == 10000 {
                    do {
                        let json = result["data"]
                        let client = JSON(try json["client"].rawData())
                        let parameters2 = [
                            "token": json["access_token"].stringValue,
                            "is_cj": "10001",
                        ]
                        
                        self?.AFTask("/Api/During/information", parameters: parameters2) { result2 in
                            if let result2 = try? result2.get() {
                                do {
                                    let json2 = try JSON(result2["data"].rawData())
                                    let account = BAAccount(
                                        token: json["access_token"].stringValue,
                                        userName: client["username"].stringValue,
                                        sex: json2["sex"].stringValue,
                                        headImgUrl: client["head_img"].stringValue,
                                        identity: client["identity"].stringValue,
                                        phone: client["phone"].stringValue,
                                        userId: client["student_id"].stringValue,
                                        major: json2["major"].stringValue,
                                        _class: json2["class"].stringValue
                                    )
                                    
                                    completion(.success(account))
                                } catch {
                                    completion(.failure(.parseErr))
                                }
                            } else {
                                print("DEBUG: Get BY Information Failed.")
                                completion(.failure(.badRequest))
                            }
                        }
                    } catch {
                        completion(.failure(.parseErr))
                    }
                }
            } else {
                print("DEBUG: Login BY Failed.")
                completion(.failure(.noData))
            }
        }
    }
    
    /**
     *  获取所有的公开活动
     *
     *  - Parameters:
     *      - status: 活动状态
     *      - offset: 前n个活动
     *      - completion: 结果回调 `[BAEvent]`
     */
    func publicEvents(status: EventStatus, by offset: Int, _ completion: @escaping (Result<[BAEvent], JCError>) -> Void) {
        let parameters = ["status": String(status.rawValue)]
        
        events(for: "/Api/List/index", parameters: parameters, by: offset, completion)
    }
    
    /**
     *  获取所有的公开活动，按照活动类型筛选
     *
     *  - Parameters:
     *      - type: 活动类型
     *      - status: 活动状态
     *      - offset: 前n个活动
     *      - completion: 结果回调 `[BAEvent]`
     */
    func publicEvents(for type: EventType, status: EventStatus, by offset: Int, _ completion: @escaping (Result<[BAEvent], JCError>) -> Void) {
        let parameters = [
            "status": String(status.rawValue),
            "project": String(type.rawValue)
        ]
        
        events(for: "/Api/List/project", parameters: parameters, by: offset, completion)
    }
    
    /**
     *  获取个人已报名和已参加的活动
     *
     *  - Parameters:
     *      - offset: 前n个活动
     *      - completion: 结果回调 `[BAEvent]`
     */
    func myEvents(by offset: Int, _ completion: @escaping (Result<[BAEvent], JCError>) -> Void) {
        guard let account = Defaults[.byAccount] else {
            completion(.failure(.notLoginBY))
            return
        }
        
        let parameters = ["token": account.token]
        AFTask("/Api/During/myDuring", parameters: parameters) { [weak self] result in
            guard let weakSelf = self else {
                completion(.failure(.selfGotReleased))
                return
            }
            
            if let result = try? result.get() {
                let jsonArr = result["data"].arrayValue
                let size = min(jsonArr.count, offset)
                var eventsArr: [BAEvent] = []
                
                (0 ..< size).forEach {
                    let json = jsonArr[$0]
                    let event = BAEvent(
                        eventID: json["id"].intValue,
                        eventName: json["titleing"].stringValue,
                        coverUrl: json["cover"].stringValue,
                        hospital: json["hospital"].stringValue,
                        startDate: weakSelf.string2Date(json["during_start"].stringValue),
                        type: json["project"].stringValue,
                        place: json["place"].stringValue,
                        maxCount: json["minimum"].intValue,
                        regCount: json["reg_num"].intValue,
                        status: json["status"].intValue
                    )
                    
                    eventsArr.append(event)
                }
                
                completion(.success(eventsArr))
            } else {
                print("DEBUG: Fetch My Events Failed.")
                completion(.failure(.noData))
            }
        }
    }
    
    /**
     *  报名参加活动
     *
     *  - Parameters:
     *      - eventID: 活动id
     *      - completion: 报名结果回调 `String`
    */
    func signUp(for eventID: Int, _ completion: @escaping (Result<String, JCError>) -> Void) {
        guard let account = Defaults[.byAccount] else {
            completion(.failure(.notLoginBY))
            return
        }
        
        let parameters = [
            "token": account.token,
            "url": String(eventID)
        ]
        
        AFTask("/Api/During/sign", parameters: parameters) { result in
            if let result = try? result.get() {
                completion(.success(result["type"].stringValue))
            } else {
                print("DEBUG: Failed To Sign Up Event.")
                completion(.failure(.noData))
            }
        }
    }
    
    /**
     *  取消参加活动
     *
     *  - Parameters:
     *      - eventID: 活动id
     *      - completion: 取消结果回调 `String`
    */
    func cancel(for eventID: Int, _ completion: @escaping (Result<String, JCError>) -> Void) {
        guard let account = Defaults[.byAccount] else {
            completion(.failure(.notLoginBY))
            return
        }
        
        let parameters = [
            "token": account.token,
            "url": String(eventID)
        ]
        
        AFTask("/Api/During/cancel", parameters: parameters) { result in
            if let result = try? result.get() {
                completion(.success(result["type"].stringValue))
            } else {
                print("DEBUG: Failed To Cancel Event.")
                completion(.failure(.noData))
            }
        }
    }
    
    /**
     *  获取用户的百叶积分
     *
     *  - Parameters:
     *      - completion: 取消结果回调 `BAScore`
    */
    func getScore(_ completion: @escaping (Result<BAScore, JCError>) -> Void) {
        guard let account = Defaults[.byAccount] else {
            completion(.failure(.notLoginBY))
            return
        }
        
        let parameters = ["token": account.token]
        
        AFTask("/Api/During/integral", parameters: parameters) { result in
            if let result = try? result.get() {
                let json = result["data"]
                let score = BAScore(
                    all: json["all"].intValue,
                    bx: json["bx"].intValue,
                    dx: json["dx"].intValue,
                    md: json["md"].intValue,
                    jm: json["jm"].intValue
                )
                
                completion(.success(score))
            } else {
                print("DEBUG: Failed To Get BY Score.")
                completion(.failure(.noData))
            }
        }
    }
    
    /**
     *  获取用户的加分记录
     *
     *  - Parameters:
     *      - completion: 结果回调 `BAScoreAdding`
    */
    func getScoreAddingRecords(_ completion: @escaping (Result<[BAScoreAdding], JCError>) -> Void) {
        guard let account = Defaults[.byAccount] else {
            completion(.failure(.notLoginBY))
            return
        }
        
        var parameters = ["token": account.token]
        
        // 正常参加活动加分
        AFTask("/Api/Index/integral", parameters: parameters) { result in
            if let result = try? result.get() {
                let jsonArr = result["data"].arrayValue
                var recordsArr: [BAScoreAdding] = []
                
                jsonArr.forEach { json in
                    let during = json["during"]
                    let record = BAScoreAdding(
                        eventName: during["titleing"].stringValue,
                        eventID: json["did"].intValue,
                        score: json["num"].intValue,
                        type: json["project"].stringValue,
                        reason: "正常扫码签到加分"
                    )
                    
                    recordsArr.append(record)
                }
                
                completion(.success(recordsArr))
            } else {
                print("DEBUG: Failed To Cancel Event.")
                completion(.failure(.noData))
            }
        }
        
        parameters["status"] = "2"
        
        // 后台加分
        AFTask("/Api/Apply/record", parameters: parameters) { result in
            if let result = try? result.get() {
                let jsonArr = result["data"].arrayValue
                var recordsArr: [BAScoreAdding] = []
                
                jsonArr.forEach { json in
                    let record = BAScoreAdding(
                        eventName: json["remarks"].stringValue.replacingOccurrences(of: "\n", with: ""),
                        eventID: json["did"].intValue,
                        score: json["num"].intValue,
                        type: json["project"].stringValue,
                        reason: json["during"].stringValue
                    )
                    
                    recordsArr.append(record)
                }
                
                completion(.success(recordsArr))
            } else {
                print("DEBUG: Failed To Cancel Event.")
                completion(.failure(.noData))
            }
        }
    }
}


// MARK: Private Methods -
extension BAAccountManager {
    
    /**
     * A wrapped method for Alamofire request task.
     *
     * - Parameters:
     *      - path: url路径
     *      - parameters: request请求参数
     *      - completion: 结果回调 `JSON`
     */
    private func AFTask(_ path: String, parameters: [String: String]?, completion: @escaping (Result<JSON, JCError>) -> Void) {
        AF.request(
            apiLink + path,
            method: .post,
            parameters: parameters,
            requestModifier: { $0.timeoutInterval = 10 }
        ).response { response in
            switch response.result {
            case .success:
                guard
                    let statusCode = response.response?.statusCode,
                    statusCode == 200,
                    let data = response.data
                else {
                    completion(.failure(.noData))
                    return
                }
                
                do {
                    let json = try JSON(data: data)
                    completion(.success(json))
                } catch {
                    completion(.failure(.parseErr))
                }
                
            case .failure(let error):
                if error._code == NSURLErrorTimedOut {
                    completion(.failure(.timeout))
                    print("DEBUG: BY Request Timeout.")
                } else {
                    completion(.failure(.badRequest))
                    print("DEBUG: BY Request Failed With Error: \(String(describing: error)).")
                }
            }
        }
    }
    
    /**
     *  通过url，获取特定活动
     *
     *  - Parameters:
     *      - url: 活动链接
     *      - offset: 前n个活动
     *      - completion: 结果回调 `BAEvent`
     */
    private func events(for path: String, parameters: [String: String]?, by offset: Int, _ completion: @escaping (Result<[BAEvent], JCError>) -> Void) {
        AFTask(path, parameters: parameters) { [weak self] result in
            guard let weakSelf = self else {
                completion(.failure(.selfGotReleased))
                return
            }
            
            if let result = try? result.get() {
                let jsonArr = result["data"].arrayValue
                let size = min(jsonArr.count, offset)
                var eventArr: [BAEvent] = []
                
                (0 ..< size).forEach {
                    let json = jsonArr[$0]
                    let event = BAEvent(
                        eventID: json["id"].intValue,
                        eventName: json["titleing"].stringValue,
                        coverUrl: json["cover"].stringValue,
                        hospital: json["hospital"].stringValue,
                        startDate: weakSelf.string2Date(json["during_start"].stringValue),
                        type: json["project"].stringValue,
                        place: json["place"].stringValue,
                        maxCount: json["minimum"].intValue,
                        regCount: json["reg_num"].intValue,
                        status: json["status"].intValue
                    )
                    
                    eventArr.append(event)
                }
                
                completion(.success(eventArr))
            } else {
                print("DEBUG: Fetch Events Failed.")
                completion(.failure(.noData))
            }
        }
    }
    
    private func string2Date(_ string: String, dateFormat: String = "yyyy-MM-dd") -> Date {
        let formatter = DateFormatter()
        formatter.locale = Locale.init(identifier: "zh_CN")
        formatter.dateFormat = dateFormat
        
        return formatter.date(from: string) ?? Date(timeIntervalSince1970: 0)
    }
}
