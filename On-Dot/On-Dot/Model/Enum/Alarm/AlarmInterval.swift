//
//  AlarmInterval.swift
//  On-Dot
//
//  Created by 현수 노트북 on 4/26/25.
//

enum AlarmInterval: Int, CaseIterable, Identifiable {
    case one = 1
    case three = 3
    case five = 5
    case ten = 10
    case thirty = 30
    case sixty = 60

    var id: Int { rawValue }

    var displayName: String {
        switch self {
        case .one: return "1분"
        case .three: return "3분"
        case .five: return "5분"
        case .ten: return "10분"
        case .thirty: return "30분"
        case .sixty: return "60분"
        }
    }
}
