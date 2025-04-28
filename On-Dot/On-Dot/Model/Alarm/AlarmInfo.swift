//
//  AlarmInfo.swift
//  On-Dot
//
//  Created by 현수 노트북 on 4/15/25.
//

import Foundation

struct AlarmInfo: Codable {
    let alarmMode: String
    let isEnabled: Bool?
    let triggeredAt: String
    let isSnoozeEnabled: Bool
    let snoozeInterval: Int
    let snoozeCount: Int
    let soundCategory: String
    let ringTone: String
    let volume: Float
    
    static let placeholder = AlarmInfo(
        alarmMode: "VIBRATE",
        isEnabled: true,
        triggeredAt: "2025-05-10T18:30:00",
        isSnoozeEnabled: true,
        snoozeInterval: 5,
        snoozeCount: 3,
        soundCategory: "BIRD",
        ringTone: "morning.mp3",
        volume: 7
    )
}

extension AlarmInfo {
    var triggeredDate: Date? {
        let formatter = ISO8601DateFormatter()
        return formatter.date(from: triggeredAt)
    }
}
