//
//  DBManager.swift
//  JavaClub-iOS
//
//  Created by Roy Rao on 2021/9/14.
//

import Foundation
import SQLite

enum SQLiteError: Error {
    case openDatabase(message: String)
    case prepare(message: String)
    case step(message: String)
    case bind(message: String)
}

class DBManager {
    private var db: Connection?
    // Table
    private var _table: Table!
    // Columns
    var id: Expression<String>!
    var name: Expression<String>!
    var locale: Expression<String>!
    var teacher: Expression<String>!
    var day: Expression<String>!
    var isLong: Expression<Bool>!
    var weekSet: [Int64]!
    
    init() {
        do {
            let path = NSSearchPathForDirectoriesInDomains(
                .documentDirectory,
                .userDomainMask,
                true
            ).first!

            db = try Connection("\(path)/db.sqlite3")
            _table = Table("Users")
            id = Expression<String>("id")
            name = Expression<String>("name")
            teacher = Expression<String>("teacher")
            locale = Expression<String>("locale")
            day = Expression<String>("day")
            isLong = Expression<Bool>("indexSet")
            
            if (!UserDefaults.standard.bool(forKey: "is_db_created")) {
             
                // if not, then create the table
                try db!.run(_table.create { t in
                    t.column(id, primaryKey: true)
                    t.column(name)
                    t.column(locale)
                    t.column(teacher)
                    t.column(day)
                    t.column(isLong)
                })
                 
                // set the value to true, so it will not attempt to create the table again
                UserDefaults.standard.set(true, forKey: "is_db_created")
            }
        } catch {
            print("ERR: \(error.localizedDescription)")
        }
    }
}


// MARK: Shared Methods -
extension DBManager {
    
}
