//
//  ScheduleRequest.swift
//  On-Dot
//
//  Created by 현수 노트북 on 4/15/25.
//

struct ScheduleRequest: Codable {
    let title: String
    let isRepeat: Bool
    let repeatDays: [Int]
    let appointmentAt: String
    let departurePlace: LocationInfo
    let arrivalPlace: LocationInfo
    let preparationAlarm: AlarmInfo
    let departureAlarm: AlarmInfo
}
