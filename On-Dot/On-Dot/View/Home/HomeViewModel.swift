//
//  HomeViewModel.swift
//  On-Dot
//
//  Created by 현수 노트북 on 4/13/25.
//

import SwiftUI

final class HomeViewModel: ObservableObject {
    @Published var scheduleList: [ScheduleModel] = []
    @Published var isShrunk: Bool = false
    @Published var showDeleteCompletionToast: Bool = false
    
    // MARK: - EditSchedule State
    @Published var editableSchedule: ScheduleInfo = .placeholder
    @Published var lastFocusedField: FocusField = .from
    
    private var recentlyDeleted: (item: ScheduleModel, index: Int)?
    
    init() {
        loadSampleData()
    }
    
    private func loadSampleData() {
        scheduleList = [
            ScheduleModel(id: 1, title: "일정1", isRepeat: false, repeatDays: [], appointmentAt: Date(), preparationTriggeredAt: Date(), departureTriggeredAt: Date(), isEnabled: true),
            ScheduleModel(id: 2, title: "일정2", isRepeat: false, repeatDays: [], appointmentAt: Date(), preparationTriggeredAt: nil, departureTriggeredAt: Date(), isEnabled: false),
            ScheduleModel(id: 3, title: "일정3", isRepeat: true, repeatDays: [1, 7], appointmentAt: Date(), preparationTriggeredAt: Date(), departureTriggeredAt: Date(), isEnabled: false)
        ]
    }
    
    func deleteSchedule(id: Int) {
        if let index = scheduleList.firstIndex(where: { $0.id == id }) {
            let deletedItem = scheduleList[index]
            recentlyDeleted = (item: deletedItem, index: index)
            scheduleList.remove(at: index)
            showDeleteCompletionToast = true
            
            let summary = scheduleList.map { "(\($0.id): \($0.title))" }.joined(separator: ", ")
            print("Schedule List: [\(summary)]")
        }
    }
    
    func updateScheduleAlarmEnabled(id: Int, isOn: Bool) {
        if let index = scheduleList.firstIndex(where: { $0.id == id }) {
            scheduleList[index].isEnabled = isOn
            
            let summary = scheduleList.map { "(\($0.id): \($0.isEnabled))" }.joined(separator: ", ")
            print("Schedule List: [\(summary)]")
        }
    }
    
    // 방금 삭제한 일정 되돌리기
    func restoreDeletedSchedule() {
        guard let backup = recentlyDeleted else { return }
        scheduleList.insert(backup.item, at: backup.index)
        recentlyDeleted = nil
        showDeleteCompletionToast = false
        
        print("복원 완료 → \(backup.item.title) at index \(backup.index)")
    }
}

extension HomeViewModel {
    var appointmentDate: Date? {
        return try? DateFormatterUtil.parseSimpleDate(from: editableSchedule.appointmentAt)
    }
    
    var formattedDate: String {
        if let date = appointmentDate {
            return DateFormatterUtil.formatDate(date, separator: "-")
        }
        return "-"
    }
    
    var formattedTime: String {
        if let date = appointmentDate {
            return DateFormatterUtil.formatTime(date)
        }
        return "-"
    }
}
