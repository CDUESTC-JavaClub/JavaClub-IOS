//
//  BaiAccountManager.swift
//  JavaClub
//
//  Created by Nago Coler on 2021/10/3.
//

import Foundation
import Alamofire
import SwiftyJSON
import SwiftUI

class BaiAccountManage{
    static let api = "http://byjh.cduestc.cn"   //http://byjh.cduestc.cn:1356 是外网端口，但是目前失效，可能学校以后会重新启用
    static var account : BaiAccount? = nil
    static func initAccount(id : String, password : String){   //学号密码
        let account = BaiAccount(id: id, password: password)
        account.login();
    }
}

class BaiAccount{
    var id : String
    var password : String
    var token : String? = nil     //必须有token，才能执行任何操作
    
    /* 用户名，登陆成功后才能拿到 */
    var userName : String? = nil
    /* 用户头像链接，登陆成功后才能拿到 */
    var headImgUrl : String? = nil
    /* 所属部门，登陆成功后才能拿到 */
    var identity : String? = nil
    /* 电话号码，登陆成功后才能拿到 */
    var phone : String? = nil
    /* 百叶计划内部ID号，登陆成功后才能拿到 */
    var userId : String? = nil
    /* 专业，登陆成功后才能拿到 */
    var major : String? = nil
    /* 班级，登陆成功后才能拿到 */
    var clazz : String? = nil
    /* 性别，登陆成功后才能拿到 */
    var sex : String? = nil
    
    init(id : String, password : String){
        self.id = id
        self.password = password
    }
    
    /*
     是否登陆
     */
    public func isLogin() -> Bool{
        return token != nil
    }
    
    /*
     登陆后才能使用其他功能
     */
    public func login(){
        let parameters = [
            "student_id": self.id,
            "password": self.password]
        
        self.netTask(parameters: parameters, url: "/Api/Token/login", task: { data in
            let status = data["status"].stringValue
            if status == "10000" {
                let json = data["data"]
                self.token = json["access_token"].stringValue
                
                let client = JSON(try json["client"].rawData())
                self.userName = client["username"].stringValue
                self.userId = client["student_id"].stringValue
                self.identity = client["identity"].stringValue
                self.phone = client["phone"].stringValue
                self.headImgUrl = client["head_img"].stringValue
                
                
                let parameters2 = [
                    "token": self.token,
                    "is_cj": "10001"]
                self.netTask(parameters: parameters2, url: "/Api/During/information") { data in
                    let json = try JSON(data["data"].rawData())
                    self.sex = json["sex"].stringValue
                    self.major = json["major"].stringValue
                    self.clazz = json["class"].stringValue
                    
                    //DEBUG
                    self.myActivity(limit: 10, consumer: { a in
                        if a is SignedActivity{
                            let sa = a as! SignedActivity
                            print("个人活动："+sa.name+String(sa.id)+" > "+sa.check_code)
                        }else{
                            print("普通活动："+a.name+String(a.id))
                        }
                    })
                }
            }
        })
    }
    
    /**
     *  获取并操作所有的活动
     *
     *  - Parameters:
     *      - type: 活动状态
     *      - limit: 前n个活动
     *      - consumer: 消费者
     */
    func allActivity(type : StatusType, limit : Int, consumer : @escaping (Activity) -> Void){
        let parameters = ["status": String(type.rawValue)]
        self.activitiesRequest(parameters: parameters, url: "/Api/List/index", limit: limit, consumer: consumer)
    }
    
    /**
     *  获取并操作所有的活动，按照活动类型筛选
     *
     *  - Parameters:
     *      - type: 活动状态
     *      - type2: 活动类型
     *      - limit: 前n个活动
     *      - consumer: 消费者
     */
    func allActivityByType(type : StatusType, type2 : ActivityType, limit : Int, consumer : @escaping (Activity) -> Void){
        let parameters = ["status": String(type.rawValue), "project" : String(type2.rawValue)]
        self.activitiesRequest(parameters: parameters, url: "/Api/List/project", limit: limit, consumer: consumer)
    }
    
    func activitiesRequest(parameters : [String:String?], url : String, limit : Int, consumer : @escaping (Activity) -> Void){
        self.netTask(parameters: parameters, url: url, task: { data in
            let array : [JSON] = data["data"].arrayValue
            let size = min(array.count, limit)
            
            for i in 0..<size{
                let item = array[i]
                let activity = Activity(id: item["id"].intValue, name: item["titleing"].stringValue, coverUrl: item["cover"].stringValue, hospital: item["hospital"].stringValue, start: self.string2Date(item["during_start"].stringValue), type: item["project"].stringValue, place: item["place"].stringValue, max: item["minimum"].intValue, reg: item["reg_num"].intValue, status: item["status"].stringValue)
                consumer(activity)
            }
        })
    }
    
    func myActivity(limit : Int, consumer : @escaping (Activity) -> Void){
        let parameters = ["token": self.token]
        self.netTask(parameters: parameters, url: "/Api/During/myDuring", task: { data in
            let array : [JSON] = (data)["data"].arrayValue
            let size = min(array.count, limit)
            
            for i in 0..<size{
                let item = array[i]
                let activity = SignedActivity(id: item["id"].intValue, name: item["titleing"].stringValue, coverUrl: item["cover"].stringValue, hospital: item["hospital"].stringValue, start: self.string2Date(item["during_start"].stringValue), type: item["project"].stringValue, place: item["place"].stringValue, max: item["minimum"].intValue, reg: item["reg_num"].intValue, status: item["status"].stringValue, qr_code: item["qr_code"].stringValue, check_code: item["check_code"].stringValue, stat: item["stat"].stringValue)
                consumer(activity)
            }
        })
    }
    
    private func string2Date(_ string:String, dateFormat:String = "yyyy-MM-dd") -> Date {
        let formatter = DateFormatter()
        formatter.locale = Locale.init(identifier: "zh_CN")
        formatter.dateFormat = dateFormat
        let date = formatter.date(from: string)
        return date!
    }
    
    private func netTask(parameters : [String:String?], url : String, task : @escaping (JSON) throws -> Void){
        AF.request(
            BaiAccountManage.api+url,
            method: .post,
            parameters: parameters
        ).response { response in
            do{
                let data = JSON(response.data!)
                try task(data)
            }catch{
                print("Json error")
            }
        }
    }
}

enum ActivityType : Int{
    case BX = 1
    case DX = 2
    case JM = 3
    case MD = 4
}

enum StatusType : Int{
    /* 所有活动 */
    case ALL = 0
    /* 正在报名的活动 */
    case SIGNING = 4
    /* 报名结束的活动 */
    case READY = 5
    /* 活动正在进行 */
    case ACTIVE = 7
    /* 已结束的活动 */
    case END = 8
}

class Activity{
    /* 活动编号 */
    let id : Int;
    /* 活动名称 */
    let name : String
    /* 活动图标 */
    let coverUrl : String
    /* 还不清楚到底是个什么，暂时保留 */
    let hospital : String
    /* 开始时间 */
    let start : Date
    /* 类型 */
    let type : String
    /* 地点 */
    let place : String
    /* 最大参加人数 */
    let max : Int
    /* 当前参加人数 */
    let reg : Int
    /* 活动状态 */
    let status : String
    
    init(id : Int, name :String, coverUrl : String, hospital : String, start : Date, type : String, place : String, max : Int, reg : Int, status : String){
        self.id = id
        self.name = name
        self.coverUrl = coverUrl
        self.hospital = hospital
        self.start = start
        self.type = type
        self.place = place
        self.max =  max
        self.reg = reg
        self.status = status
    }
}

class SignedActivity : Activity{
    var qr_code : String
    var check_code : String
    var stat : String
    
    init(id : Int, name :String, coverUrl : String, hospital : String, start : Date, type : String, place : String, max : Int, reg : Int, status : String, qr_code : String, check_code : String, stat : String){
        self.qr_code = qr_code
        self.check_code = check_code
        self.stat = stat
        super.init(id: id, name: name, coverUrl: coverUrl, hospital: hospital, start: start, type: type, place: place, max: max, reg: reg, status: status)
    }
}
