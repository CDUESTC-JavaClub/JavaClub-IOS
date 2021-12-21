//
//  JCDateManager.swift
//  JavaClub
//
//  Created by Roy on 2021/10/28.
//

import Foundation
import Defaults

class JCTermManager {
    static let shared = JCTermManager()
    
    private init() {}
}


// MARK: Shared Methods -
extension JCTermManager {
    
    func term() -> Int? {
        guard let enrollmentInfo = Defaults[.enrollment] else {
            logger.warning("Get Current Term Failed: No Enrollment Info.")
            return nil
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        let index = enrollmentInfo.dateEnrolled.index(enrollmentInfo.dateEnrolled.startIndex, offsetBy: 9)
        let abbreviatedDate = String(enrollmentInfo.dateEnrolled.prefix(through: index))
        
        if
            let dateEnrolled = formatter.date(from: abbreviatedDate),
            let yearPassed = Calendar.current.dateComponents([.year], from: dateEnrolled, to: Date()).year,
            let currentMonth = Calendar.current.dateComponents([.month], from: Date()).month
        {
            let termAdd = yearPassed * 2
            let result = 1 + termAdd + termCheck(with: currentMonth)
            
            return result > 8 ? 8 : result
        }
        
        return nil
    }
    
    func formatted(for term: Int) -> String? {
        guard
            let enrollmentInfo = Defaults[.enrollment],
            enrollmentInfo.degree == "本科" && (1 ... 8).contains(term) ||
                enrollmentInfo.degree == "专科" && (1 ... 6).contains(term)
        else {
            logger.warning("Get Duration Failed: No Enrollment Info Or Invalid Term.")
            return nil
        }
        
        let first = [1, 3, 5, 7]
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        let index = enrollmentInfo.dateEnrolled.index(enrollmentInfo.dateEnrolled.startIndex, offsetBy: 9)
        let abbreviatedDate = String(enrollmentInfo.dateEnrolled.prefix(through: index))
        
        if let dateEnrolled = formatter.date(from: abbreviatedDate) {
            let yearPassed = term / 2
            
            var dateComponents = DateComponents()
            dateComponents.year = yearPassed
            
            if
                let futureDate = Calendar.current.date(byAdding: dateComponents, to: dateEnrolled),
                let futureYear = Calendar.current.dateComponents([.year], from: futureDate).year
            {
                return String.localized("%@-%@ 学年（%@）", with: "\(futureYear)", "\(futureYear + 1)", "\(first.contains(term) ? "上".localized() : "下".localized())")
            }
        }
        
        return nil
    }
}


// MARK: Private Methods -
extension JCTermManager {
    
    private func termCheck(with month: Int) -> Int {
        if (9 ... 12).contains(month) || (1 ..< 3).contains(month) {
            return 0
        } else {
            return 1
        }
    }
}
