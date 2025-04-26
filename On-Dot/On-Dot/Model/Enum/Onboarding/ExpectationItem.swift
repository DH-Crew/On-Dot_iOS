//
//  ExpectationItem.swift
//  On-Dot
//
//  Created by 현수 노트북 on 4/26/25.
//

import Foundation

struct ExpectationItem: Identifiable, Equatable {
    let id = UUID()
    let imageName: String
    let title: String
}
