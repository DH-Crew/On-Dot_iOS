//
//  AlarmInfo.swift
//  On-Dot
//
//  Created by 현수 노트북 on 4/15/25.
//

struct AlarmInfo: Codable {
    let alarmMode: String
    let isEnabled: Bool?
    let triggeredAt: String
    let mission: String?
    let isSnoozeEnabled: Bool
    let snoozeInterval: Int
    let snoozeCount: Int
    let soundCategory: String
    let ringTone: String
    let volume: Int
}
