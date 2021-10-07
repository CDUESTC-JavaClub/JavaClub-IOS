//
//  BaiAccount.swift
//  JavaClub
//
//  Created by Roy Rao on 2021/10/4.
//

import Foundation

struct BaiAccount {
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
}
