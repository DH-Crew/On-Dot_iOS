//
//  Constants.swift
//  On-Dot
//
//  Created by 현수 노트북 on 4/10/25.
//

enum AppConstants {
    static let weekdaySymbolsKR = ["일", "월", "화", "수", "목", "금", "토"]
    static let repeatTypeTitles = ["매일", "평일", "주말"]
}

enum RepeatType: Int, CaseIterable {
    case daily = 0
    case weekly = 1
    case monthly = 2
    
    var title: String {
        return AppConstants.repeatTypeTitles[self.rawValue]
    }
}
