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
    static func formatDate(_ date: Date, separator: String = ".") -> String {
        dateFormatter.dateFormat = "yyyy\(separator)MM\(separator)dd"
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
    
    /// 첫 번째 Date에서 날짜를 가져오고, 두 번째 Date에서 시간을 가져와 새로운 Date 생성
    static func combineDateAndTime(date: Date, time: Date) -> Date? {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(identifier: "Asia/Seoul")!

        let dateComponents = calendar.dateComponents([.year, .month, .day], from: date)
        let timeComponents = calendar.dateComponents([.hour, .minute, .second], from: time)

        var combinedComponents = DateComponents()
        combinedComponents.year = dateComponents.year
        combinedComponents.month = dateComponents.month
        combinedComponents.day = dateComponents.day
        combinedComponents.hour = timeComponents.hour
        combinedComponents.minute = timeComponents.minute
        combinedComponents.second = timeComponents.second

        return calendar.date(from: combinedComponents)
    }
}
