//
//  ConfirmScheduleView.swift
//  On-Dot
//
//  Created by 현수 노트북 on 4/26/25.
//

import SwiftUI

struct ConfirmEditScheduleView: View {
    @State private var showDeleteScheduleDialog: Bool = false
    @State private var showDateBottomSheet: Bool = false
    @State private var showTimeBottomSheet: Bool = false
    @State private var showEmptyDateToast: Bool = false
    @State private var showTimePickerBottomSheet: Bool = false
    @State private var timePickerAlarmType: AlarmType = .departure  // TimePicker를 렌더링할 때 선택된 알람이 준비 알람인지, 출발 알람인지 구분
    @State private var alarmMeridiem: String = "" // TimePicker에서 사용되는 meridiem
    @State private var alarmHour: Int = 0 // TimePicker에서 사용되는 hour
    @State private var alarmMinute: Int = 0 // TimePicker에서 사용되는 minute
    @Binding var scheduleTitle: String
    @Binding var lastFocusedField: FocusField
    @Binding var fromLocation: String
    @Binding var toLocation: String
    @Binding var isRepeatOn: Bool
    @Binding var isChecked: Bool
    @Binding var meridiem: String
    @Binding var hour: Int
    @Binding var minute: Int
    @FocusState private var focusedField: FocusField?
    @FocusState private var focusState: Bool
    
    let formattedSelectedDate: String?
    let formattedSelectedTime: String
    let selectedWeekdays: Set<Int>
    let isConfirmMode: Bool
    let departureAlarm: AlarmInfo
    let preparationAlarm: AlarmInfo
    let activeCheckChip: Int?
    let selectedDate: Date?
    let selectedTime: Date?
    let referenceDate: Date
    
    var onClickCreateButton: () -> Void
    var onClickBackButton: () -> Void
    var onClickDeleteButton: () -> Void = {}
    var onClickToggle: () -> Void = {}
    var onClickCheckTextChip: (Int) -> Void = { _ in }
    var onClickTextChip: (Int) -> Void = { _ in }
    var onClickAlarmToggle: (Bool) -> Void = {_ in}
    var increaseMonth: () -> Void = {}
    var decreaseMonth: () -> Void = {}
    var onClickDate: (Date) -> Void = { _ in }
    var updateSelectedTime: () -> Void = {}
    var updateTriggeredAt: (AlarmType, String, Int, Int) -> Void = {_, _, _, _ in}
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            Color.gray900.ignoresSafeArea()
            
            VStack(spacing: 0) {
                ConfirmEditScheduleTopBar(scheduleTitle: $scheduleTitle, focusState: $focusState, onClickBackButton: onClickBackButton)
                
                ScrollView {
                    VStack(spacing: 16) {
                        SelectedDateTimeView(
                            selectedDate: isRepeatOn ? nil : formattedSelectedDate,
                            selectedTime: formattedSelectedTime,
                            selectedWeekdays: selectedWeekdays,
                            isConfirmMode: true,
                            backgroundColor: .green900
                        )
                        .simultaneousGesture(
                            TapGesture().onEnded {
                                if !isConfirmMode {
                                    withAnimation {
                                        showDateBottomSheet = true
                                    }
                                }
                            }
                        )
                        
                        FromToLocationView(
                            fromLocation: $fromLocation,
                            toLocation: $toLocation,
                            lastFocusedField: $lastFocusedField,
                            focusedField: $focusedField,
                            isConfirmMode: true,
                            backgroundColor: .green900,
                            closeButtonColor: .green700
                        )
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top, 11)
                    .padding(.bottom, 16)
                    .padding(.horizontal, 22)
                    .background(Color.gradientGreenBottom)
                    
                    Spacer().frame(height: 20)
                    
                    ConfirmEditAlarmView(
                        isOn: departureAlarm.isEnabled ?? true,
                        type: .departure,
                        alarmInfo: departureAlarm,
                        onClickAlarmView: { type, meri, h, m in
                            timePickerAlarmType = type
                            alarmMeridiem = meri
                            alarmHour = h
                            alarmMinute = m
                            
                            showTimePickerBottomSheet = true
                        }
                    )
                    
                    Spacer().frame(height: 20)
                    
                    ConfirmEditAlarmView(
                        isOn: preparationAlarm.isEnabled ?? true,
                        type: .preparation,
                        alarmInfo: preparationAlarm,
                        onClickToggle: onClickAlarmToggle,
                        onClickAlarmView: { type, meri, h, m in
                            timePickerAlarmType = type
                            alarmMeridiem = meri
                            alarmHour = h
                            alarmMinute = m
                            
                            showTimePickerBottomSheet = true
                        }
                    )
                    
                    if !isConfirmMode {
                        Spacer().frame(height: 32)
                        
                        Button(action: { showDeleteScheduleDialog = true }) {
                            Text("알람 삭제")
                                .font(OnDotTypo.bodyLargeSB)
                                .foregroundStyle(Color.red)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.gray700)
                                )
                                .padding(.horizontal, 22)
                        }
                    }
                }
                
                Spacer()
                
                OnDotButton(
                    content: isConfirmMode ? "일정 생성" : "저장",
                    action: {
                        if selectedDate == nil && selectedWeekdays.isEmpty {
                            showEmptyDateToast = true
                        } else {
                            onClickCreateButton()
                        }
                    },
                    style: isConfirmMode ? .outline : .green500
                )
                .padding(.horizontal, 22)
                .padding(.bottom, 16)
            }
            
            if showDeleteScheduleDialog {
                OnDotDialog(
                    title: "알람 삭제",
                    content: "정말 알람을 삭제하시겠어요?",
                    positiveButtonText: "확인",
                    negativeButtonText: "취소",
                    onClickBtnPositive: onClickDeleteButton,
                    onClickBtnNegative: { showDeleteScheduleDialog = false },
                    onDismissRequest: { showDeleteScheduleDialog = false }
                )
            }
            
            if showDateBottomSheet {
                OnDotBottomSheet(
                    onDismissRequest: {
                        withAnimation {
                            showDateBottomSheet = false
                        }
                    }
                ) {
                    VStack {
                        ScrollView {
                            RepeatSettingView(
                                isOn: $isRepeatOn,
                                isChecked: $isChecked,
                                activeCheckChip: activeCheckChip,
                                activeWeekdays: selectedWeekdays,
                                onClickToggle: onClickToggle,
                                onClickCheckTextChip: onClickCheckTextChip,
                                onClickTextChip: onClickTextChip
                            )
                            
                            DateTimeSettingView(
                                selectedDate: selectedDate,
                                selectedTime: selectedTime,
                                referenceDate: referenceDate,
                                isActiveCalendar: true,
                                isActiveTimePicker: true,
                                activeWeekdays: selectedWeekdays,
                                meridiem: $meridiem,
                                hour: $hour,
                                minute: $minute,
                                increaseMonth: increaseMonth,
                                decreaseMonth: decreaseMonth,
                                onClickDate: onClickDate,
                                updateSelectedTime: updateSelectedTime
                            )
                        }
                        
                        Spacer().frame(height: 20)
                        
                        OnDotButton(
                            content: "완료",
                            action: {
                                withAnimation {
                                    showDateBottomSheet = false
                                }
                            },
                            style: .green500
                        )
                    }
                }
            }
            
            if showTimePickerBottomSheet {
                OnDotBottomSheet(
                    maxHeight: 300,
                    onDismissRequest: { showTimePickerBottomSheet = false },
                    content: {
                        TimePickerBottomSheetContentView(
                            meridiem: $alarmMeridiem,
                            hour: $alarmHour,
                            minute: $alarmMinute,
                            onClickCompletionButton: {
                                updateTriggeredAt(timePickerAlarmType, alarmMeridiem, alarmHour, alarmMinute)
                                showTimePickerBottomSheet = false
                            }
                        )
                    }
                )
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .toast(isPresented: $showEmptyDateToast, isDelete: false, message: "날짜를 선택해주세요")
        .simultaneousGesture(
            TapGesture()
                .onEnded {
                    if focusState { focusState = false }
                }
        )
    }
}

private struct ConfirmEditScheduleTopBar: View {
    @Binding var scheduleTitle: String
    @FocusState.Binding var focusState: Bool
    
    var onClickBackButton: () -> Void
    
    var body: some View {
        HStack(alignment: .center, spacing: 0) {
             Image("ic_back")
                .resizable()
                .renderingMode(.template)
                .foregroundStyle(Color.gray800)
                .frame(width: 24, height: 24)
                .onTapGesture {
                    onClickBackButton()
                }
            
            Spacer().frame(width: 20)
            
            HStack(spacing: 4) {
                ZStack(alignment: .leading) {
                    if !focusState {
                        Text(scheduleTitle)
                            .font(OnDotTypo.titleSmallM)
                            .foregroundStyle(Color.gray800)
                    }
                    TextField("", text: $scheduleTitle)
                        .focused($focusState)
                        .font(OnDotTypo.titleSmallM)
                        .foregroundColor(Color.gray800)
                        .accentColor(.gray800)
                        .opacity(focusState ? 1 : 0)
                        .lineLimit(1)
                }

                Image("ic_pencil")
                    .resizable()
                    .renderingMode(.template)
                    .foregroundStyle(Color.gray800)
                    .frame(width: 20, height: 20)
                    .onTapGesture {
                        focusState = true
                    }
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .padding(.bottom, 12)
        .padding(.top, 28)
        .padding(.horizontal, 16)
        .background(Color.gradientGreenTop)
    }
}

private struct ConfirmEditAlarmView: View {
    @State var isOn: Bool
    
    let type: AlarmType
    let alarmInfo: AlarmInfo
    
    var onClickToggle: (Bool) -> Void = {_ in}
    var onClickAlarmView: (AlarmType, String, Int, Int) -> Void = {_, _, _, _ in}
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text(type == AlarmType.departure ? "출발 알람" : "준비시작 알람")
                    .font(OnDotTypo.bodyLargeR2)
                    .foregroundStyle(Color.gray50)
                
                Spacer()
            }
            .padding(.horizontal, 20)
            
            HStack(alignment: .lastTextBaseline, spacing: 8) {
                Text(DateFormatterUtil.formatMeridiem(alarmInfo.triggeredDate ?? Date()))
                    .font(OnDotTypo.titleMediumL)
                    .foregroundStyle(Color.gray50)
                
                Text(DateFormatterUtil.formatHourMinute(alarmInfo.triggeredDate ?? Date()))
                    .font(OnDotTypo.titleLargeL)
                    .foregroundStyle(Color.gray50)
                
                Spacer()
                
                if type == AlarmType.preparation { OnDotToggle(isOn: $isOn, action: { onClickToggle(isOn) }) }
            }
            .padding(.horizontal, 20)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(Color.gray700)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .padding(.horizontal, 22)
        .contentShape(Rectangle())
        .onTapGesture {
            let (meridiem, hour, minute) = DateFormatterUtil.extractMeridiemHourMinute(from: alarmInfo.triggeredDate ?? Date())
            onClickAlarmView(type, meridiem, hour, minute)
        }
    }
    
    @ViewBuilder
    private func menuItem(
        title: String,
        content: String
    ) -> some View {
        HStack(spacing: 0) {
            Text(title)
                .font(OnDotTypo.bodyMediumM)
                .foregroundStyle(Color.gray200)
            
            Spacer()
            
            Text(content)
                .font(OnDotTypo.bodyMediumM)
                .foregroundStyle(Color.gray200)
            
            Spacer().frame(width: 8)
            
            Image("ic_arrow_right")
                .resizable()
                .renderingMode(.template)
                .foregroundStyle(Color.gray400)
                .frame(width: 20, height: 20)
        }
        .padding(.horizontal, 20)
    }
}

private struct TimePickerBottomSheetContentView: View {
    @Binding var meridiem: String
    @Binding var hour: Int
    @Binding var minute: Int
    
    var onClickCompletionButton: () -> Void
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            Text("알람 시간 수정")
                .font(OnDotTypo.bodyLargeR1)
                .foregroundStyle(Color.gray0)
            
            Spacer().frame(height: 16)
            
            Rectangle().fill(Color.gray600).frame(height: 0.5).padding(.horizontal, 4)
            
            Spacer().frame(height: 16)
            
            DialTimePickerView(meridiem: $meridiem, hour: $hour, minute: $minute, by: 1)
            
            Spacer().frame(height: 16)
            
            OnDotButton(
                content: "완료",
                action: onClickCompletionButton,
                style: .green500
            )
        }
    }
}
