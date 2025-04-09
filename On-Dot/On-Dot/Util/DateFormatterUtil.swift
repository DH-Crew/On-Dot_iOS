//
//  DateFormatter.swift
//  On-Dot
//
//  Created by 현수 노트북 on 4/10/25.
//

import Foundation

struct DateFormatterUtil {
    
    /// 날짜를 "yyyy.MM.dd" 형식으로 반환
    static func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: date)
    }

    /// 시간을 "오전/오후 h:mm" 형식으로 반환
    static func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "a hh:mm"
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.amSymbol = "오전"
        formatter.pmSymbol = "오후"
        return formatter.string(from: date)
    }

    /// 날짜 + 시간 형식으로 반환 (예: "2025.04.08 오전 9:00")
    static func formatDateTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd a hh:mm"
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.amSymbol = "오전"
        formatter.pmSymbol = "오후"
        return formatter.string(from: date)
    }
    
    /// 날짜를 "M월 d일 h:mm" 형식으로 반환 (예: "6월 13일 7:00")
    static func formatShortKoreanDateTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "M월 d일 H:mm"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: date)
    }
}
