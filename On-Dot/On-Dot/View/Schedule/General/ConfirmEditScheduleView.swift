//
//  ConfirmScheduleView.swift
//  On-Dot
//
//  Created by 현수 노트북 on 4/26/25.
//

import SwiftUI

struct ConfirmEditScheduleView: View {
    @State private var showDeleteScheduleDialog: Bool = false
    @Binding var scheduleTitle: String
    @Binding var lastFocusedField: FocusField
    @Binding var fromLocation: String
    @Binding var toLocation: String
    @FocusState private var focusedField: FocusField?
    
    let selectedDate: String?
    let selectedTime: String
    let selectedWeekdays: Set<Int>
    let isConfirmMode: Bool
    let departureAlarm: AlarmInfo
    let preparationAlarm: AlarmInfo
    
    var onClickCreateButton: () -> Void
    var onClickBackButton: () -> Void
    var onClickDeleteButton: () -> Void = {}
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            Color.gray900.ignoresSafeArea()
            
            VStack(spacing: 0) {
                ConfirmEditScheduleTopBar(scheduleTitle: $scheduleTitle, onClickBackButton: onClickBackButton)
                
                ScrollView {
                    VStack(spacing: 16) {
                        SelectedDateTimeView(
                            selectedDate: selectedDate,
                            selectedTime: selectedTime,
                            selectedWeekdays: selectedWeekdays,
                            isConfirmMode: true,
                            backgroundColor: .green900
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
                        alarmInfo: departureAlarm
                    )
                    
                    Spacer().frame(height: 20)
                    
                    ConfirmEditAlarmView(
                        isOn: preparationAlarm.isEnabled ?? true,
                        type: .preparation,
                        alarmInfo: preparationAlarm
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
                    action: onClickCreateButton,
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
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

private struct ConfirmEditScheduleTopBar: View {
    @Binding var scheduleTitle: String
    
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
            
            Text(scheduleTitle)
                .font(OnDotTypo.titleSmallM)
                .foregroundStyle(Color.gray800)
            
            Spacer().frame(width: 4)
            
            Image("ic_pencil")
                .resizable()
                .renderingMode(.template)
                .foregroundStyle(Color.gray800)
                .frame(width: 20, height: 20)
            
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
                
                if type == AlarmType.preparation { OnDotToggle(isOn: $isOn) }
            }
            .padding(.horizontal, 20)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(Color.gray700)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .padding(.horizontal, 22)
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
