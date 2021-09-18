//
//  KAClassTableView.swift
//  JavaClub-iOS
//
//  Created by Roy Rao on 2021/9/12.
//

import SwiftUI

struct KAClassTableView: View {
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 10), count: 7)
        
    var body: some View {
        VStack {
            Text("本科 2019-2020 学年（上）")
                .font(.title)
            
            LazyVGrid(columns: columns, spacing: 5) {
                ForEach(1 ..< 8) { index in
                    Text("周\(index)")
                }
            }
            .padding(.vertical, 5)
            .background(Color.green.opacity(0.1))
            
            ScrollView(.vertical, showsIndicators: false) {
                
            }
        }
        .padding(.horizontal)
    }
}
