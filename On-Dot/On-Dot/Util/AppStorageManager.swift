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
    
    func saveSelectedSound(fileName: String) {
        UserDefaults.standard.set(fileName, forKey: alarmSoundKey)
    }
    
    func getSelectedSound() -> String? {
        return UserDefaults.standard.string(forKey: alarmSoundKey)
    }
    
    func clearSelectedSound() {
        UserDefaults.standard.removeObject(forKey: alarmSoundKey)
    }
}
