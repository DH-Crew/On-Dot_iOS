//
//  HomeViewModel.swift
//  On-Dot
//
//  Created by 현수 노트북 on 4/13/25.
//

import SwiftUI

final class HomeViewModel: ObservableObject {
    private let scheduleRepository: ScheduleRepository
    
    @Published var scheduleList: [HomeScheduleInfo] = []
    @Published var isShrunk: Bool = false
    @Published var showDeleteCompletionToast: Bool = false
    @Published var earliestAlarmAt: Date? = nil
    
    // MARK: - EditSchedule State
    @Published var editableSchedule: ScheduleInfo = .placeholder
    @Published var lastFocusedField: FocusField = .from
    var editableScheduleId: Int = -1
    
    private var recentlyDeleted: (item: HomeScheduleInfo, index: Int)?
    
    init(
        scheduleRepository: ScheduleRepository = ScheduleRepositoryImpl()
    ) {
        self.scheduleRepository = scheduleRepository
    }
    
    private func loadSampleData() {
        scheduleList = [
            HomeScheduleInfo(id: 1, title: "일정1", isRepeat: false, repeatDays: [], appointmentAt: Date(), nextAlarmAt: Date(), preparationTriggeredAt: Date(), departureTriggeredAt: Date(), isEnabled: true),
            HomeScheduleInfo(id: 2, title: "일정2", isRepeat: false, repeatDays: [], appointmentAt: Date(), nextAlarmAt: Date(), preparationTriggeredAt: nil, departureTriggeredAt: Date(), isEnabled: false),
            HomeScheduleInfo(id: 3, title: "일정3", isRepeat: true, repeatDays: [1, 7], appointmentAt: Date(), nextAlarmAt: Date(), preparationTriggeredAt: Date(), departureTriggeredAt: Date(), isEnabled: false)
        ]
    }
    
    func getSchedules() async {
        do {
            let response = try await scheduleRepository.getSchedules()
            
            await MainActor.run {
                scheduleList = response.scheduleList
                earliestAlarmAt = response.earliestAlarmAt
            }
        } catch {
            print("홈 일정 조회 실패: \(error)")
        }
    }
    
    func getScheduleDetail(id: Int) async {
        do {
            let response = try await scheduleRepository.getScheduleDetail(id: id)
            
            await MainActor.run {
                editableSchedule = response
            }
        } catch {
            print("일정 상세 조회 실패: \(error)")
        }
    }
    
    func deleteSchedule(id: Int) async {
        do {
            await MainActor.run {
                guard let index = scheduleList.firstIndex(where: { $0.id == id }) else { return }
                
                let deletedItem = scheduleList[index]
                recentlyDeleted = (item: deletedItem, index: index)
                scheduleList.remove(at: index)
                showDeleteCompletionToast = true
            }
            
            try await scheduleRepository.deleteSchedule(id: id)
            await getSchedules()
        } catch {
            print("일정 삭제 실패: \(error)")
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
    var formattedDate: String {
        return DateFormatterUtil.formatDate(editableSchedule.appointmentAt, separator: "-")
    }
    
    var formattedTime: String {
        return DateFormatterUtil.formatTime(editableSchedule.appointmentAt)
    }
}
