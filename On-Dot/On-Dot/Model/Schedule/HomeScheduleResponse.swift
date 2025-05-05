//
//  HomeScheduleResponse.swift
//  On-Dot
//
//  Created by 현수 노트북 on 5/2/25.
//

import Foundation

struct HomeScheduleResponse: Codable {
    let isOnboardingCompleted: Bool
    let earliestAlarmAt: Date?
    let hasNext: Bool
    let scheduleList: [HomeScheduleInfo]
}
