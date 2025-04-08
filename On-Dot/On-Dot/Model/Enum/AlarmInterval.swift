//
//  AlarmInterval.swift
//  On-Dot
//
//  Created by 현수 노트북 on 4/8/25.
//

enum AlarmInterval: Int, CaseIterable, Identifiable {
    case one = 1, three = 3, five = 5, ten = 10, thirty = 30, sixty = 60
    
    var id: Int { rawValue }
    var label: String { "\(rawValue)분" }
}
