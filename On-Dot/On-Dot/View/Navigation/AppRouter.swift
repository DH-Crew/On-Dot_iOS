//
//  AppRouter.swift
//  On-Dot
//
//  Created by 현수 노트북 on 4/12/25.
//

import SwiftUI

final class AppRouter: ObservableObject {
    static let shared = AppRouter() 
    private let appStorageManager: AppStorageManager
    private let scheduleRepository: ScheduleRepository
    
    @Published var state: AppState
    @Published var path: [AppState] = []
    @Published var schedule: HomeScheduleInfo = .placeholder
    @Published var interval: Int = 0
    @Published var repeatCount: Int = -1
    @Published var alarmType: String = ""
    @Published var isSnoozed = false
    @Published var showPreparationStartAnimation: Bool = false
    
    private var currentScheduleId: Int = -1
    
    private init(
        appStorageManager: AppStorageManager = AppStorageManager.shared,
        scheduleRepository: ScheduleRepository = ScheduleRepositoryImpl()
    ) {
        self.appStorageManager = appStorageManager
        self.scheduleRepository = scheduleRepository
        self.state = .splash
        self.isSnoozed = appStorageManager.getIsSnoozed()
        
        if let userInfo = PendingPushManager.shared.userInfo {
            if let id = userInfo["id"] as? Int, appStorageManager.getSchedule(id: id) != nil {
                handleNotificationPayload(userInfo)
            } else {
                print("로컬에 해당 일정이 없습니다. 화면 전환 생략합니다.")
            }
            PendingPushManager.shared.userInfo = nil
        } 
    }
    
    func navigate(to newState: AppState) {
        path.append(newState)
    }
    
    func replace(with newState: AppState) {
        path = [newState]
    }
    
    func goBack() {
        if !path.isEmpty {
            path.removeLast()
        }
    }
    
    func handleNotificationPayload(_ userInfo: [AnyHashable: Any]) {
        if let target = userInfo["navigate"] as? String,
           target == "alarmRing",
           let type = userInfo["type"] as? String,
           let id = userInfo["id"] as? Int {
            currentScheduleId = id
            
            if let scheduleInfo = appStorageManager.getSchedule(id: id) {
                self.schedule = scheduleInfo
            }
            
            if type == "prep" { state = .preparation }
            else if type == "depart" { state = .departure }
            
            alarmType = type
            interval = appStorageManager.getInterval()?.rawValue ?? 3
            repeatCount = appStorageManager.getRepeatCount()?.count ?? 0
            isSnoozed = false

            print("scheduleInfo: \(schedule)")
        }
    }
    
    func onClickDelayButton() {
        isSnoozed = true
        appStorageManager.saveIsSnoozed(isSnoozed)
        let snoozedTime = Date().addingTimeInterval(TimeInterval(interval * 60))
        AlarmPlayer.shared.stop()
        AlarmService.shared.scheduleTimer(id: schedule.id, type: alarmType, at: snoozedTime)
        AlarmService.shared.scheduleLocalNotification(id: schedule.id, type: alarmType, at: snoozedTime)
    }
    
    func onPreparationStarted() {
        isSnoozed = false
        appStorageManager.saveIsSnoozed(isSnoozed)
        state = .splash
        showPreparationStartAnimation = true
    }
    
    func onClickNavigateButton() {
        Task {
            await removeSchedule()
            await MainActor.run {
                isSnoozed = false
                appStorageManager.saveIsSnoozed(isSnoozed)
                state = .splash
                PendingPushManager.shared.userInfo = nil
            }
        }
    }
    
    private func removeSchedule() async {
        do {
            guard currentScheduleId > 0 else { return }
            appStorageManager.removeSchedule(id: currentScheduleId)
            try await scheduleRepository.deleteSchedule(id: currentScheduleId)
        } catch {
            print("일정 삭제 실패: \(error)")
        }
    }
}
