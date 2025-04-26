//
//  AlarmSound.swift
//  On-Dot
//
//  Created by 현수 노트북 on 4/23/25.
//

import Foundation

struct AlarmSound: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let fileName: String
}
