//
//  KAClassTableColorSelector.swift
//  JavaClub
//
//  Created by Roy on 2021/10/22.
//

import Foundation

class KAClassTableColorSelector: ObservableObject {
    static let shared = KAClassTableColorSelector()
    
    @Published var colorHash: [String?] = Array(repeating: nil, count: 20)
    
    let colorSet: [String] = [
        "#CCCD5C5C", "#CCFFA500", "#CCEEDD82", "#CC00FF7F", "#CC63B8FF",
        "#CC436EEE", "#CCFFE4C4", "#CCD15FEE", "#CCFFA54F", "#CCCDBA96",
        "#CC32CD32", "#CC32CD32", "#CC20B2AA", "#CCFFAEB9", "#CC9370DB",
        "#CC00BFFF", "#CC00FA9A", "#CCEECFA1", "#CCF0E68C", "#CCFF69B4",
    ]
}
