//
//  AlarmCategory.swift
//  On-Dot
//
//  Created by 현수 노트북 on 4/23/25.
//

enum AlarmCategory: String, CaseIterable, Identifiable {
    case category1 = "BRIGHT_ENERGY"
    case category2 = "FAST_INTENSE"

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .category1: return "밝은 에너지"
        case .category2: return "빠르고 강렬한"
        }
    }
}
