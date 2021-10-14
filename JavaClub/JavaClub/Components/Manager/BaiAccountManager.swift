////
////  BaiAccountManager.swift
////  JavaClub
////
////  Created by Nago Coler on 2021/10/3.
////
//
//import Foundation
//import Alamofire
//import SwiftyJSON
//import SwiftUI
//
//enum ActivityType : Int {
//    case BX = 1
//    case DX = 2
//    case JM = 3
//    case MD = 4
//}
//
//enum StatusType : Int {
//    /* 所有活动 */
//    case ALL = 0
//    /* 正在报名的活动 */
//    case SIGNING = 4
//    /* 报名结束的活动 */
//    case READY = 5
//    /* 活动正在进行 */
//    case ACTIVE = 7
//    /* 已结束的活动 */
//    case END = 8
//}
//
//
//class BaiAccountManager {
//    static let shared = BaiAccountManager()
//    static let api = "http://byjh.cduestc.cn"   // http://byjh.cduestc.cn:1356 是外网端口，但是目前失效，可能学校以后会重新启用
//    private(set) var account : BaiAccount?
//
//
//    private init() {
//
//    }
//}
//
//
//extension BaiAccountManager {
//
//    /**
//     *  务必在使用前进行初始化，如果希望登陆后立即执行某些操作，可以写在afterLogin进行回调
//     *  - Parameters:
//     *      - id: 学号
//     *      - password: 密码
//     *      - afterLogin: 登陆成功后同线程操作
//     *      - onFailed: 无法连接教务情况的操作（一般是外网无法访问）
//     */
//    public func initAccount(
//        id : String,
//        password : String,
//        afterLogin : @escaping (BaiAccount) -> Void,
//        onFailed: @escaping ()-> Void
//    ) {
//        account = BaiAccount(id: id, password: password)
//        login(afterLogin, onFailed: onFailed)
//    }
//
//    /*
//     是否登陆
//     */
//    public func isLogin() -> Bool {
//        account?.token != nil
//    }
//
//    /*
//     登陆后才能使用其他功能
//     */
//    public func login(_ afterLogin : @escaping (BaiAccount) -> Void, onFailed: @escaping ()-> Void) {
//        if var account = account {
//            let parameters = [
//                "student_id": account.id,
//                "password": account.password]
//
//            netTask(parameters: parameters, url: "/Api/Token/login", task: { [weak self] data in
//                let status = data["status"].stringValue
//                if status == "10000" {
//                    let json = data["data"]
//                    account.token = json["access_token"].stringValue
//
//                    let client = JSON(try json["client"].rawData())
//                    account.userName = client["username"].stringValue
//                    account.userId = client["student_id"].stringValue
//                    account.identity = client["identity"].stringValue
//                    account.phone = client["phone"].stringValue
//                    account.headImgUrl = client["head_img"].stringValue
//
//
//                    let parameters2 = [
//                        "token": account.token,
//                        "is_cj": "10001",
//                    ]
//                    netTask(parameters: parameters2, url: "/Api/During/information") { data in
//                        let json = try JSON(data["data"].rawData())
//                        account.sex = json["sex"].stringValue
//                        account.major = json["major"].stringValue
//                        account.clazz = json["class"].stringValue
//
//                        afterLogin(account)
//                    }
//                }
//            }, onFailed: onFailed)
//        }
//    }
//
//    /**
//     *  获取并操作所有的活动
//     *
//     *  - Parameters:
//     *      - type: 活动状态
//     *      - limit: 前n个活动
//     *      - consumer: 消费者
//     */
//    func allActivity(type : StatusType, limit : Int, consumer : @escaping (Activity) -> Void){
//        let parameters = ["status": String(type.rawValue)]
//        activitiesRequest(parameters: parameters, url: "/Api/List/index", limit: limit, consumer: consumer)
//    }
//
//    /**
//     *  获取并操作所有的活动，按照活动类型筛选
//     *
//     *  - Parameters:
//     *      - type: 活动状态
//     *      - type2: 活动类型
//     *      - limit: 前n个活动
//     *      - consumer: 消费者
//     */
//    func allActivityByType(type : StatusType, type2 : ActivityType, limit : Int, consumer : @escaping (Activity) -> Void) {
//        let parameters = ["status": String(type.rawValue), "project" : String(type2.rawValue)]
//        activitiesRequest(parameters: parameters, url: "/Api/List/project", limit: limit, consumer: consumer)
//    }
//
//    func activitiesRequest(parameters : [String:String?], url : String, limit : Int, consumer : @escaping (Activity) -> Void){
//        netTask(parameters: parameters, url: url, task: { [weak self] data in
//            let array : [JSON] = data["data"].arrayValue
//            let size = min(array.count, limit)
//
//            for i in 0 ..< size {
//                let item = array[i]
//                let activity = Activity(id: item["id"].intValue, name: item["titleing"].stringValue, coverUrl: item["cover"].stringValue, hospital: item["hospital"].stringValue, start: string2Date(item["during_start"].stringValue), type: item["project"].stringValue, place: item["place"].stringValue, max: item["minimum"].intValue, reg: item["reg_num"].intValue, status: item["status"].stringValue)
//                consumer(activity)
//            }
//        })
//    }
//
//    /**
//     *  获取个人已报名和已参加的活动
//     *
//     *  - Parameters:
//     *      - limit: 前n个活动
//     *      - consumer: 消费者
//     */
//    func myActivity(limit : Int, consumer : @escaping (Activity) -> Void) {
//        guard account != nil else { return }
//
//        let parameters = ["token": account!.token]
//        netTask(parameters: parameters, url: "/Api/During/myDuring", task: { [weak self] data in
//            let array : [JSON] = (data)["data"].arrayValue
//            let size = min(array.count, limit)
//
//            for i in 0..<size {
//                let item = array[i]
//                let activity = SignedActivity(id: item["id"].intValue, name: item["titleing"].stringValue, coverUrl: item["cover"].stringValue, hospital: item["hospital"].stringValue, start: self?.string2Date(item["during_start"].stringValue), type: item["project"].stringValue, place: item["place"].stringValue, max: item["minimum"].intValue, reg: item["reg_num"].intValue, status: item["status"].stringValue, qr_code: item["qr_code"].stringValue, check_code: item["check_code"].stringValue, stat: item["stat"].stringValue)
//                consumer(activity)
//            }
//        })
//    }
//
//    /**
//     *  报名参加活动
//     *
//     *  - Parameters:
//     *      - activityId: 活动id
//     *      - callback: 报名结果回调
//    */
//    func signActivity(activityId : Int, callback : @escaping (String) -> Void){
//        let parameters = ["token": token,
//                          "url":String(activityId)]
//        netTask(parameters: parameters, url: "/Api/During/sign") { data in
//            callback(data["type"].stringValue)
//        }
//    }
//
//    /**
//     *  取消参加活动
//     *
//     *  - Parameters:
//     *      - activityId: 活动id
//     *      - callback: 报名结果回调
//    */
//    func cancelActivity(activityId : Int, callback : @escaping (String) -> Void){
//        let parameters = ["token": token,
//                          "url":String(activityId)]
//        netTask(parameters: parameters, url: "/Api/During/cancel") { data in
//            callback(data["type"].stringValue)
//        }
//    }
//
//    /**
//     *  获取用户的百叶积分
//     *
//     *  - Parameters:
//     *      - callback: 百叶积分结果回调
//    */
//    func getScore(callback : @escaping (ScoreData) -> Void){
//        let parameters = ["token": token]
//        netTask(parameters: parameters, url: "/Api/During/integral") { data in
//            let json = JSON(data["data"].rawValue)
//            let score = ScoreData(a : json["all"].intValue, b : json["bx"].intValue, c : json["dx"].intValue, d : json["md"].intValue, e : json["jm"].intValue)
//            callback(score)
//        }
//    }
//
//    /**
//     *  获取用户的百叶积分
//     *
//     *  - Parameters:
//     *      - callback: 加分记录结果回调
//    */
//    func getScoreAddList(callback : @escaping (ScoreAdd) -> Void){
//        var parameters = ["token": token]
//        netTask(parameters: parameters, url: "/Api/Index/integral") { data in   //正常参加活动加分
//            let arr : [JSON] = data["data"].arrayValue
//            for i in 0..<arr.count {
//                let json = arr[i]
//                let dur = JSON(json["during"].rawValue)
//                callback(ScoreAdd(a: dur["titleing"].stringValue, b: json["did"].intValue, c: json["num"].intValue, d: json["project"].stringValue, e: "正常扫码签到加分"))
//            }
//        }
//        parameters["status"] = "2"
//        netTask(parameters: parameters, url: "/Api/Apply/record") { data in   //后台加分
//            let arr : [JSON] = data["data"].arrayValue
//            for i in 0..<arr.count {
//                let json = arr[i]
//                callback(ScoreAdd(a: json["remarks"].stringValue.replacingOccurrences(of: "\n", with: ""), b: json["did"].intValue, c: json["num"].intValue, d: json["project"].stringValue, e: json["during"].stringValue))
//            }
//        }
//    }
//
//    private func string2Date(_ string:String, dateFormat:String = "yyyy-MM-dd") -> Date {
//        let formatter = DateFormatter()
//        formatter.locale = Locale.init(identifier: "zh_CN")
//        formatter.dateFormat = dateFormat
//        let date = formatter.date(from: string)
//        return date!
//    }
//
//    private func netTask(parameters : [String:String?], url : String, task : @escaping (JSON) throws -> Void){
//        netTask(parameters: parameters, url: url, task: task) {
//            print(url+" 请求失败！")
//        }
//    }
//
//    private func netTask(parameters : [String: String?], url : String, task : @escaping (JSON) throws -> Void, onFailed : @escaping () -> Void) {
//        AF.request(
//            BaiAccountManager.api + url,
//            method: .post,
//            parameters: parameters
//        ).response { response in
//            do {
//                if(response.response == nil || response.response?.statusCode != 200) {
//                    onFailed()
//                } else {
//                    let data = JSON(response.data!)
//                    try task(data)
//                }
//            } catch {
//                print("Json error")
//            }
//        }
//    }
//}
