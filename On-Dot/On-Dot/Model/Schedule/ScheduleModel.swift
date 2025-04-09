//
//  ScheduleModel.swift
//  On-Dot
//
//  Created by 현수 노트북 on 4/10/25.
//

struct ScheduleModel: Codable, Identifiable {
    let id: Int
    let title: String
    let isRepeat: Bool
    let repeatDays: [Int]
    let appointmentAt: Date
    let preparationTriggeredAt: Date
    let departureTriggeredAt: Date
    let isEnabled: Bool

    enum CodingKeys: String, CodingKey {
        case id = "scheduleId"
        case title = "scheduleTitle"
        case isRepeat
        case repeatDays = "repeatDay"
        case appointmentAt
        case preparationTriggeredAt
        case departureTriggeredAt
        case isEnabled
    }
}
