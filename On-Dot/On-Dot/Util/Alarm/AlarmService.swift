//
//  AlarmService.swift
//  On-Dot
//
//  Created by 현수 노트북 on 5/4/25.
//

import SwiftUI
import UserNotifications

final class AlarmService {
    static let shared = AlarmService()
    private init() {}

    private var timers: [String: Timer] = [:]  // key = "\(scheduleId)-prep/departure"

    /// 홈뷰에서 스케줄 목록을 받아 호출
    func scheduleAlarms(for schedules: [HomeScheduleInfo]) {
        cancelAll()

        for info in schedules {
            let id = info.id
            // 준비 알람 (Optional)
            if let prepDate = info.preparationTriggeredAt {
                scheduleTimer(id: id, type: "prep", at: prepDate)
                scheduleLocalNotification(id: id, type: "prep", at: prepDate)
            }
            // 출발 알람 (필수)
            let depDate = info.departureTriggeredAt
            scheduleTimer(id: id, type: "depart", at: depDate)
            scheduleLocalNotification(id: id, type: "depart", at: depDate)
        }
    }

    /// 모든 타이머/노티 취소
    func cancelAll() {
        timers.values.forEach { $0.invalidate() }
        timers.removeAll()
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }

    // MARK: - 1) 포그라운드용 Timer

    private func scheduleTimer(id: Int, type: String, at date: Date) {
        let key = "\(id)-\(type)"
        let interval = date.timeIntervalSinceNow
        guard interval > 0 else { return }

        let timer = Timer(timeInterval: interval, repeats: false) { [weak self] _ in
            self?.playAlarm()
            self?.timers.removeValue(forKey: key)
        }
        RunLoop.main.add(timer, forMode: .common)      // .common 모드로 등록
        RunLoop.main.add(timer, forMode: .default)     // 기본 모드에도 등록
        timers[key] = timer
    }

    // MARK: - 2) 백그라운드용 Local Notification

    private func scheduleLocalNotification(id: Int, type: String, at date: Date) {
        let content = UNMutableNotificationContent()
        content.title = "⏰ \(type == "prep" ? "준비 시간입니다" : "출발 시간입니다")"
        content.body  = ""
        content.userInfo = ["navigate": "alarmRing", "type": type]
        
        let fileName = AppStorageManager.shared.getSelectedSound() ?? "chasing_lights.caf"
        content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: fileName))

        // identifier를 같게 해두면 중복 스케줄을 덮어쓰기 좋습니다
        let request = UNNotificationRequest(
            identifier: "\(id)-\(type)",
            content: content,
            trigger: UNCalendarNotificationTrigger(
                dateMatching: Calendar.current.dateComponents(
                    [.year, .month, .day, .hour, .minute, .second],
                    from: date
                ),
                repeats: false
            )
        )
        
        print("[알림 등록] \(id)-\(type) → \(date)")
        
        UNUserNotificationCenter.current().add(request)
    }

    // MARK: - 공통 재생 로직

    func playAlarm() {
        // 1) 무음 모드 체크
//        if AppStorageManager.shared.getMuteMode() { return }
//
//        // 2) 볼륨, 반복 횟수, 간격
//        let volume     = AppStorageManager.shared.getSelectedVolume()
//        let loops      = AppStorageManager.shared.getRepeatCount()?.count ?? 3
//        let interval   = AppStorageManager.shared.getInterval()?.rawValue ?? 5
//
//        // 3) 사운드 파일 결정
//        let fileName = AppStorageManager.shared.getSelectedSound() ?? "chasing_lights.caf"
//
//        AlarmPlayer.shared.setVolume(volume)
//        AlarmPlayer.shared.play(soundFileName: fileName, numberOfLoops: loops)
//
//        // 4) 만약 ‘반복 간격’을 추가로 지원하려면…
//        guard loops > 0, interval > 0 else { return }
//        DispatchQueue.main.asyncAfter(deadline: .now() + Double(interval) * Double(loops)) {
//            AlarmPlayer.shared.play(soundFileName: fileName, numberOfLoops: 0)
//        }
    }
}
