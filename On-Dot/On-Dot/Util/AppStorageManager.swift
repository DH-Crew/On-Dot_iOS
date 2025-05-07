//
//  AppStorageManager.swift
//  On-Dot
//
//  Created by 현수 노트북 on 4/23/25.
//

import Combine
import SwiftUI

final class AppStorageManager {
    static let shared = AppStorageManager()
    
    private let alarmSoundKey = "selectedAlarmSound"
    private let muteModeKey = "muteMode"
    private let volumeKey = "volume"
    private let intervalKey = "interval"
    private let repeatCountKey = "repeatCount"
    private let isSnoozedKey = "isSnoozed"
    
    private init() {}
    
    func saveSelectedSound(fileName: String) {
        UserDefaults.standard.set(fileName, forKey: alarmSoundKey)
    }
    
    func getSelectedSound() -> String? {
        return UserDefaults.standard.string(forKey: alarmSoundKey)
    }
    
    func clearSelectedSound() {
        UserDefaults.standard.removeObject(forKey: alarmSoundKey)
    }
    
    func saveMuteMode(value: Bool) {
        UserDefaults.standard.set(value, forKey: muteModeKey)
    }
    
    func getMuteMode() -> Bool {
        return UserDefaults.standard.bool(forKey: muteModeKey)
    }
    
    func saveSelectedVolume(volume: Float) {
        UserDefaults.standard.set(volume, forKey: volumeKey)
    }
    
    func getSelectedVolume() -> Float {
        let savedValue = UserDefaults.standard.float(forKey: volumeKey)
        return savedValue == 0.0 ? 0.5 : savedValue
    }
    
    func saveInterval(interval: AlarmInterval) {
        UserDefaults.standard.set(interval.rawValue, forKey: intervalKey)
    }
    
    func getInterval() -> AlarmInterval? {
        let savedValue = UserDefaults.standard.integer(forKey: intervalKey)
        return AlarmInterval(rawValue: savedValue)
    }
    
    func saveRepeatCount(repeatCount: RepeatCount) {
        UserDefaults.standard.set(repeatCount.rawValue, forKey: repeatCountKey)
    }
    
    func getRepeatCount() -> RepeatCount? {
        guard let savedValue = UserDefaults.standard.string(forKey: repeatCountKey) else { return nil }
        return RepeatCount(rawValue: savedValue)
    }
    
    // MARK: - 일정 정보 저장, 조회
    func saveSchedule(_ info: HomeScheduleInfo) {
        let data = try? JSONEncoder().encode(info)
        UserDefaults.standard.set(data, forKey: "schedule-\(info.id)")
    }

    func getSchedule(id: Int) -> HomeScheduleInfo? {
        guard let data = UserDefaults.standard.data(forKey: "schedule-\(id)") else { return nil }
        return try? JSONDecoder().decode(HomeScheduleInfo.self, from: data)
    }
    
    // MARK: - 알람 미루기 여부 저장, 조회
    func saveIsSnoozed(_ isSnoozed: Bool) {
        UserDefaults.standard.set(isSnoozed, forKey: isSnoozedKey)
    }
    
    func getIsSnoozed() -> Bool {
        return UserDefaults.standard.bool(forKey: isSnoozedKey)
    }
}
