//
//  StringExtension.swift
//
//  Created by Roy Rao on 2020/4/5.
//  Copyright © 2020 RoyRao. All rights reserved.
//

import Foundation

extension String {
    
    func indexOfRepeatingCharacter(of character: Character, count: Int) -> String.Index? {
        var i = 0
        for index in self.indices {
            if self[index] == character {
                i += 1
                if count == i {
                    return index
                } else {
                    continue
                }
            }
        }
        return nil
    }
    
    func split(by length: Int) -> [String] {
        var startIndex = self.startIndex
        var results = [Substring]()

        while startIndex < self.endIndex {
            let endIndex = self.index(startIndex, offsetBy: length, limitedBy: self.endIndex) ?? self.endIndex
            results.append(self[startIndex..<endIndex])
            startIndex = endIndex
        }

        return results.map { String($0) }
    }
    
    /// Searches through a string to find valid URLs.
    /// - Returns: An array of found URLs.
    func getURLs() -> [URL] {
        var foundUrls: [URL] = []
        guard let detector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue) else {
            return foundUrls
        }

        let matches = detector.matches(
            in: self,
            options: [],
            range: NSRange(location: 0, length: self.utf16.count)
        )

        for match in matches {
            guard let range = Range(match.range, in: self),
                  let retrievedURL = URL(string: String(self[range])) else { continue }
            foundUrls.append(retrievedURL)
        }

        return foundUrls
    }
    
    func localized(withComment comment: String? = nil) -> String {
        return NSLocalizedString(self, comment: comment ?? "")
    }
}

extension String.Encoding {
    static let GB_18030_2000 = String.Encoding(rawValue: CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(CFStringEncodings.GB_18030_2000.rawValue)))
    
    static let GBK_95 = String.Encoding(rawValue: CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(CFStringEncodings.GBK_95.rawValue)))
}
