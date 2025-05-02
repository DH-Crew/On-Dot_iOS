//
//  ScheduleModel.swift
//  On-Dot
//
//  Created by 현수 노트북 on 4/10/25.
//

import Foundation

struct HomeScheduleInfo: Codable, Identifiable {
    let id: Int
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
