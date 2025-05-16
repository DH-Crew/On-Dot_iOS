//
//  ScheduleModel.swift
//  On-Dot
//
//  Created by 현수 노트북 on 4/10/25.
//

import Foundation

struct HomeScheduleInfo: Codable, Identifiable {
    let id: Int
    let startLongitude: Double
    let startLatitude: Double
    let endLongitude: Double
    let endLatitude: Double
    var title: String
    var isRepeat: Bool
    var repeatDays: [Int]
    let appointmentAt: Date
    let nextAlarmAt: Date
    let preparationTriggeredAt: Date?
    let departureTriggeredAt: Date
    var isEnabled: Bool

    enum CodingKeys: String, CodingKey {
        case id = "scheduleId"
        case startLongitude
        case startLatitude
        case endLongitude
        case endLatitude
        case title = "scheduleTitle"
        case isRepeat
        case repeatDays
        case appointmentAt
        case nextAlarmAt
        case preparationTriggeredAt
        case departureTriggeredAt
        case isEnabled
    }
    
    static let placeholder = HomeScheduleInfo(
        id: -1,
        startLongitude: 0.0,
        startLatitude: 0.0,
        endLongitude: 0.0,
        endLatitude: 0.0,
        title: "",
        isRepeat: false,
        repeatDays: [],
        appointmentAt: Date(),
        nextAlarmAt: Date(),
        preparationTriggeredAt: nil,
        departureTriggeredAt: Date(),
        isEnabled: false
    )
}
