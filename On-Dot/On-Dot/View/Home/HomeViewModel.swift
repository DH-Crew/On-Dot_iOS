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
                activeWeekdays = Set(response.repeatDays)
                selectedDate = response.appointmentAt
                selectedTime = response.appointmentAt
                meridiem = DateFormatterUtil.formatMeridiem(response.appointmentAt)
                (hour, minute) = DateFormatterUtil.extractHourAndMinute(from: response.appointmentAt)
            }
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
            
            let repeatDays = activeWeekdays.map { $0 + 1 }.sorted()
            
            try await scheduleRepository.editSchedule(
                id: editableScheduleId,
                schedule: ScheduleInfo(
                    title: editableSchedule.title,
                    isRepeat: editableSchedule.isRepeat,
                    repeatDays: repeatDays,
                    appointmentAt: selectedDate!,
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
