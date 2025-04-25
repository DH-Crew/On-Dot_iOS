//
//  RepeatCount.swift
//  On-Dot
//
//  Created by 현수 노트북 on 4/8/25.
//

enum RepeatCount: String, CaseIterable, Identifiable {
    case infinite
    case one
    case three
    case five
    case ten
    
    var id: String { rawValue }
    
    var displayName: String {
        switch self {
        case .infinite: "무한"
        case .one: "1회"
        case .three: "3회"
        case .five: "5회"
        case .ten: "10회"
        }
    }
}
