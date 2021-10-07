//
//  Activity.swift
//  JavaClub
//
//  Created by Roy Rao on 2021/10/4.
//

import Foundation

struct Activity {
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
}
