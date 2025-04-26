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
    private let intervalKey = "interval"
    private let repeatCountKey = "repeatCount"
    
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
}
