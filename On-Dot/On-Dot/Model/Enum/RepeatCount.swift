//
//  RepeatCount.swift
//  On-Dot
//
//  Created by 현수 노트북 on 4/8/25.
//

enum RepeatCount: String, CaseIterable, Identifiable {
    case infinite = "무한"
    case one = "1회"
    case three = "3회"
    case five = "5회"
    case ten = "10회"
    
    var id: String { rawValue }
}
