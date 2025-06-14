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
    @Published var isChecked: Bool = false
    @Published var activeCheckChip: Int? = nil
    @Published var activeWeekdays: Set<Int> = []  // 일(0) ~ 토(6)
    @Published var referenceDate: Date = Date()
    @Published var selectedDate: Date? = nil
    @Published var selectedTime: Date? = nil
    @Published var meridiem: String = "오전"
    @Published var hour: Int = 1
    @Published var minute: Int = 0
    let fullWeek = Array(0...6)
    let weekdays = Array(1...5)
    let weekend = [0, 6]
    var editableScheduleId: Int = -1
    
    private var recentlyDeleted: (item: HomeScheduleInfo, index: Int)?
    
    init(
        scheduleRepository: ScheduleRepository = ScheduleRepositoryImpl()
    ) {
        self.scheduleRepository = scheduleRepository
    }
    
    // MARK: - DateTimeSettingViewHandler
    func onClickToggle() {
        if !editableSchedule.isRepeat {
            activeCheckChip = nil
            activeWeekdays.removeAll()
        } else {
            selectedDate = nil
            referenceDate = Date()
        }
    }
    
    func onClickTextCheckChip(index: Int) {
        activeCheckChip = index
        switch index {
        case 0: activeWeekdays = Set(fullWeek)     // 매일
        case 1: activeWeekdays = Set(weekdays)     // 평일
        case 2: activeWeekdays = Set(weekend)      // 주말
        default: break
        }
    }
    
    func onClickTextChip(index: Int) {
        if activeWeekdays.contains(index) {
            activeWeekdays.remove(index)
        } else {
            activeWeekdays.insert(index)
        }
        
        // 요일 수동 변경 시 자동 선택 해제
        if activeWeekdays == Set(fullWeek) {
            activeCheckChip = 0
        } else if activeWeekdays == Set(weekdays) {
            activeCheckChip = 1
        } else if activeWeekdays == Set(weekend) {
            activeCheckChip = 2
        } else {
            activeCheckChip = nil
        }
    }
    
    func increaseMonth() {
        if let newDate = Calendar.current.date(byAdding: .month, value: 1, to: referenceDate) {
            referenceDate = newDate
        }
    }
    
    func decreaseMonth() {
        if let newDate = Calendar.current.date(byAdding: .month, value: -1, to: referenceDate) {
            referenceDate = newDate
        }
    }
    
    func onClickDate(date: Date) {
        selectedDate = date
        referenceDate = date
    }
    
    func updateSelectedTime() {
        var components = DateComponents()
        components.hour = meridiem == "오전" ? hour % 12 : (hour % 12 + 12)
        components.minute = minute
        
        let baseDate = selectedTime ?? Date()
        guard let hour = components.hour, let minute = components.minute else { return }
        let date = Calendar.current.date(bySettingHour: hour, minute: minute, second: 0, of: baseDate)
        
        selectedTime = date
    }
    
    func getSchedules(isSnoozed: Bool = false) async {
        do {
            let response = try await scheduleRepository.getSchedules()
            
            await MainActor.run {
                scheduleList = response.scheduleList
                
                earliestAlarmAt = response.earliestAlarmAt
                
                if !isSnoozed { AlarmService.shared.scheduleAlarms(for: scheduleList) }
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
                activeWeekdays = Set(response.repeatDays.map { $0 - 1 })
                selectedDate = response.appointmentAt
                selectedTime = response.appointmentAt
                meridiem = DateFormatterUtil.formatMeridiem(response.appointmentAt)
                (hour, minute) = DateFormatterUtil.extractHourAndMinute(from: response.appointmentAt)
            }
            
            print("ㄴㄴㄴㄴ activeWeekdays: \(activeWeekdays)")
        } catch {
            print("일정 상세 조회 실패: \(error)")
        }
    }
    
    func editSchedule() async {
        do {
            await MainActor.run {
                if editableSchedule.isRepeat {
                    selectedDate = Date()
                }
            }
            
            guard let time = selectedTime else { return }
            
            let repeatDays = activeWeekdays.map { $0 + 1 }.sorted()
            guard let combinedDate = DateFormatterUtil.combineDateAndTime(date: selectedDate ?? Date(), time: time) else { return }
            
            try await scheduleRepository.editSchedule(
                id: editableScheduleId,
                schedule: ScheduleInfo(
                    title: editableSchedule.title,
                    isRepeat: editableSchedule.isRepeat,
                    repeatDays: repeatDays,
                    appointmentAt: combinedDate,
                    departurePlace: editableSchedule.departurePlace,
                    arrivalPlace: editableSchedule.arrivalPlace,
                    preparationAlarm: editableSchedule.preparationAlarm,
                    departureAlarm: editableSchedule.departureAlarm
                )
            )
        } catch {
            print("일정 수정 실패: \(error)")
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
    
    func updateScheduleAlarmEnabled(id: Int, isOn: Bool) async {
        do {
            try await scheduleRepository.updateAlarmEnabled(id: id, request: AlarmEnabled(isEnabled: isOn))
            
            await MainActor.run {
                if let index = scheduleList.firstIndex(where: { $0.id == id }) {
                    scheduleList[index].isEnabled = isOn
                    
                    let summary = scheduleList.map { "(\($0.id): \($0.isEnabled))" }.joined(separator: ", ")
                    print("Schedule List: [\(summary)]")
                }
            }
        } catch {
            print("알람 온/오프 변경 실패: \(error)")
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
    
    // 알람 종류에 따른 알람 시간 변경 메서드
    func updateTriggeredAt(type: AlarmType, meridiem: String, hour: Int, minute: Int) {
        switch type {
        case .departure:
            let newDate = DateFormatterUtil.combineDateWithTime(
                date: editableSchedule.departureAlarm.triggeredDate ?? Date(), meridiem: meridiem, hour: hour, minute: minute
            )
            let newTriggeredAt = DateFormatterUtil.toISO8601String(from: newDate)
            editableSchedule.departureAlarm.triggeredAt = newTriggeredAt
        case .preparation:
            let newDate = DateFormatterUtil.combineDateWithTime(
                date: editableSchedule.preparationAlarm.triggeredDate ?? Date(), meridiem: meridiem, hour: hour, minute: minute
            )
            let newTriggeredAt = DateFormatterUtil.toISO8601String(from: newDate)
            editableSchedule.preparationAlarm.triggeredAt = newTriggeredAt
        }
    }
}

extension HomeViewModel {
    var formattedDate: String {
        if let date = selectedDate {
            return DateFormatterUtil.formatDate(date, separator: "-")
        } else {
            return "-"
        }
    }
    
    var formattedTime: String {
        if let time = selectedTime {
            return DateFormatterUtil.formatTime(time)
        } else {
            return "-"
        }
    }
}
