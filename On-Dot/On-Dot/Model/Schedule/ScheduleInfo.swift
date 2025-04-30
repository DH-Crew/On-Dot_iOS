//
//  ScheduleRequest.swift
//  On-Dot
//
//  Created by 현수 노트북 on 4/15/25.
//

struct ScheduleInfo: Codable {
    var title: String
    var isRepeat: Bool
    var repeatDays: [Int]
    var appointmentAt: String
    var departurePlace: LocationInfo
    var arrivalPlace: LocationInfo
    var preparationAlarm: AlarmInfo
    var departureAlarm: AlarmInfo
}

extension ScheduleInfo {
    static let placeholder = ScheduleInfo(
        title: "스터디 모임",
        isRepeat: true,
        repeatDays: [2, 4, 6],
        appointmentAt: "2025-05-10T19:00:00",
        departurePlace: LocationInfo(
            title: "집",
            roadAddress: "서울특별시 강남구 테헤란로 123",
            latitude: 37.4979,
            longitude: 127.0276
        ),
        arrivalPlace: LocationInfo(
            title: "카페",
            roadAddress: "서울특별시 서초구 서초대로 77",
            latitude: 37.501,
            longitude: 127.029
        ),
        preparationAlarm: .placeholder,
        departureAlarm: .placeholder
    )
}
