//
//  GeneralScheduleCreateViewModel.swift
//  On-Dot
//
//  Created by 현수 노트북 on 4/14/25.
//

import SwiftUI

final class GeneralScheduleCreateViewModel: ObservableObject {
    private let locationRepository: LocationRepository
    private let alarmRepository: AlarmRepository
    
    init(
        locationRepository: LocationRepository = LocationRepositoryImpl(),
        alarmRepository: AlarmRepository = AlarmRepositoryImpl()
    ) {
        self.locationRepository = locationRepository
        self.alarmRepository = alarmRepository
    }
    
    // MARK: - RepeatSettingView State
    @Published var isRepeatOn: Bool = false
    @Published var isChecked: Bool = false
    @Published var activeCheckChip: Int? = nil  // 0: 매일, 1: 평일, 2: 주말
    @Published var activeWeekdays: Set<Int> = []  // 일(0) ~ 토(6)
    let fullWeek = Array(0...6)
    let weekdays = Array(1...5)
    let weekend = [0, 6]
    
    // MARK: - DateTimeSettingView State
    @Published var selectedDate: Date? = nil
    @Published var selectedTime: Date? = nil
    @Published var referenceDate: Date = Date()
    @Published var isActiveCalendar: Bool = false
    @Published var isActiveTimePicker: Bool = false
    @Published var meridiem: String = "오전"
    @Published var hour: Int = 1
    @Published var minute: Int = 0
    
    // MARK: - FromToLocationView State
    @Published var fromLocation: String = ""
    @Published var toLocation: String = ""
    @Published var currentKeyword: String = ""
    @Published var lastFocusedField: FocusField = .from
    @Published var isFromLocationSelected: Bool = false
    @Published var isToLocationSelected: Bool = false
    @Published var selectedFromLocation: LocationInfo = .placeholder
    @Published var selectedToLocation: LocationInfo = .placeholder
    
    // MARK: - LocationSearchItemView State
    @Published var searchResult: [LocationInfo] = []
    
    // MARK: - ConfirmEditScheduleView State
    @Published var newScheduleTitle: String = "새로운 일정"
    @Published var departureAlarm: AlarmInfo = .placeholder
    @Published var preparationAlarm: AlarmInfo = .placeholder
    
    // MARK: - DateTimeSettingViewHandler
    func onClickToggle() {
        isRepeatOn.toggle()
        
        if !isRepeatOn {
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
    
    func onClickCheckBox() {
        isChecked.toggle()
    }
    
    // MARK: - DateTimeSettingView Handler
    func onClickSelectedDateView() {
        isActiveCalendar.toggle()
    }
    
    func onClickSelectedTimeView() {
        isActiveTimePicker.toggle()
    }
    
    func increaseMonth() {
        referenceDate = Calendar.current.date(byAdding: .month, value: +1, to: referenceDate)!
    }
    
    func decreaseMonth() {
        referenceDate = Calendar.current.date(byAdding: .month, value: -1, to: referenceDate)!
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
    
    // MARK: - FromToLocationView Handler
    func onValueChanged(newValue: String) async {
        do {
            let response = try await locationRepository.searchLocation(query: newValue)
            
            await MainActor.run {
                searchResult = response
            }
        } catch {
            print("Search Location Failed: \(error)")
        }
    }
    
    func onLocationSelected() async {
        do {
            guard
                let date = selectedDate,
                let time = selectedTime,
                let combinedDate = DateFormatterUtil.combineDateAndTime(date: date, time: time)
            else {
                print("""
                ❌ 필수 데이터 부족
                date: \(String(describing: selectedDate))
                time: \(String(describing: selectedTime))
                combinedDate: \(String(describing: DateFormatterUtil.combineDateAndTime(date: selectedDate ?? Date(), time: selectedTime ?? Date())))
                """)
                return
            }
            
            let appointmentAt = DateFormatterUtil.toISO8601String(from: combinedDate)

            let request = CalculateRequest(
                appointmentAt: appointmentAt,
                startLongitude: selectedFromLocation.longitude,
                startLatitude: selectedFromLocation.latitude,
                endLongitude: selectedToLocation.longitude,
                endLatitude: selectedToLocation.latitude
            )
            
            let response = try await alarmRepository.calculateAlarm(request: request)
            
            await MainActor.run {
                departureAlarm = response.departureAlarm
                preparationAlarm = response.preparationAlarm
            }
        } catch {
            print("알람 정보 계산 서버 통신 실패: \(error)")
        }
    }
    
    // MARK: - ButtonHandler
    func onClickButton() {
        
    }
    
    func onClickLocationItem(location: LocationInfo) {
        if lastFocusedField == .to {
            toLocation = location.title
            isToLocationSelected = true
        } else {
            fromLocation = location.title
            isFromLocationSelected = true
        }
    }
    
    func onClickClose(field: FocusField) {
        switch field {
        case .from:
            isFromLocationSelected = false
        case .to:
            isToLocationSelected = false
        }
    }
}

extension GeneralScheduleCreateViewModel {
    var formattedSelectedDate: String? {
        guard let date = selectedDate else { return nil }
        return DateFormatterUtil.formatDate(date, separator: "-")
    }

    var formattedSelectedTime: String {
        guard let time = selectedTime else { return "-" }
        return DateFormatterUtil.formatTime(time)
    }
}
