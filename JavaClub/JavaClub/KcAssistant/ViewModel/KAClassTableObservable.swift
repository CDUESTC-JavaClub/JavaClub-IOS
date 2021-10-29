//
//  KAClassTableColorSelector.swift
//  JavaClub
//
//  Created by Roy on 2021/10/22.
//

import Foundation
import Defaults

class KAClassTableObservable: ObservableObject {
    static let shared = KAClassTableObservable()
    
    @Published var classes: [KAClass] = []
}
