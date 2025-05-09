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
        formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
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
    
    /// 시간을 "h:mm" 형식으로 반환
    static func formatTimeNumber(_ date: Date) -> String {
        dateFormatter.dateFormat = "hh:mm"
        return dateFormatter.string(from: date)
    }
    
    // 남은 시간을 계산하는 메서드
    static func timeLeftUntil(_ futureDate: Date) -> String {
        let now = Date()
        let interval = futureDate.timeIntervalSince(now)

        guard interval > 0 else { return "0:00" }

        let totalMinutes = Int(interval / 60)
        let hours = totalMinutes / 60
        let minutes = totalMinutes % 60

        return "\(hours):\(String(format: "%02d", minutes))"
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
    
    /// 날짜를 "M월 d일 h:mm" 형식으로 반환 (예: "6월 13일 7:00")
    static func formatShortKoreanMonthDay(_ date: Date) -> String {
        dateFormatter.dateFormat = "M월 d일"
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
    
    // 날짜를 시간과 분으로 분리해서 반환 (예: 7, 20)
    static func extractHourAndMinute(from date: Date) -> (hour: Int, minute: Int) {
        let components = Calendar.current.dateComponents([.hour, .minute], from: date)
        let hour = components.hour ?? 0
        let minute = components.minute ?? 0
        return (hour, minute)
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
    
    // yyyy-MM-dd'T'HH:mm:ss 형태의 문자열 데이터를 Date로 변환하는 메서드
    static func parseSimpleDate(from string: String?) throws -> Date {
        guard let input = string, !input.isEmpty else {
            throw DateParsingError.missingValue
        }

        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"

        if let date = dateFormatter.date(from: input) {
            return date
        } else {
            throw DateParsingError.invalidFormat
        }
    }

    // Date → "2025-04-16T18:00:00" 문자열
    static func toISO8601String(from date: Date) -> String {
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return dateFormatter.string(from: date)
    }
}
