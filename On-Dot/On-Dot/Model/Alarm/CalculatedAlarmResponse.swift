//
//  CalculatedAlarmResponse.swift
//  On-Dot
//
//  Created by 현수 노트북 on 4/28/25.
//

struct CalculatedAlarmResponse: Codable {
    let preparationAlarm: AlarmInfo
    let departureAlarm: AlarmInfo
}
