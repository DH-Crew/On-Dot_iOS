//
//  DateFormatter.swift
//  On-Dot
//
//  Created by 현수 노트북 on 4/10/25.
//

import Foundation

struct DateFormatterUtil {
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter
    }()
    
    /// 날짜를 "yyyy.MM.dd" 형식으로 반환
    static func formatDate(_ date: Date) -> String {
        dateFormatter.dateFormat = "yyyy.MM.dd"
        return dateFormatter.string(from: date)
    }
    
    static func formatDateYearMonth(_ date: Date) -> String {
        dateFormatter.dateFormat = "yyyy년 MM월"
        return dateFormatter.string(from: date)
    }

    /// 시간을 "오전/오후 h:mm" 형식으로 반환
    static func formatTime(_ date: Date) -> String {
        dateFormatter.dateFormat = "a hh:mm"
        dateFormatter.amSymbol = "오전"
        dateFormatter.pmSymbol = "오후"
        return dateFormatter.string(from: date)
    }

    /// 날짜 + 시간 형식으로 반환 (예: "2025.04.08 오전 9:00")
    static func formatDateTime(_ date: Date) -> String {
        dateFormatter.dateFormat = "yyyy.MM.dd a hh:mm"
        dateFormatter.amSymbol = "오전"
        dateFormatter.pmSymbol = "오후"
        return dateFormatter.string(from: date)
    }
    
    /// 날짜를 "M월 d일 h:mm" 형식으로 반환 (예: "6월 13일 7:00")
    static func formatShortKoreanDateTime(_ date: Date) -> String {
        dateFormatter.dateFormat = "M월 d일 H:mm"
        return dateFormatter.string(from: date)
    }
    
    /// 날짜를 "오전/오후" 형식으로 반환 (예: 오전)
    static func formatMeridiem(_ date: Date) -> String {
        dateFormatter.dateFormat = "a"
        dateFormatter.amSymbol = "오전"
        dateFormatter.pmSymbol = "오후"
        return dateFormatter.string(from: date)
    }

    /// 날짜를 "h:mm" 형식으로 반환 (예: 7:00)
    static func formatHourMinute(_ date: Date) -> String {
        dateFormatter.dateFormat = "h:mm"
        return dateFormatter.string(from: date)
    }
}
