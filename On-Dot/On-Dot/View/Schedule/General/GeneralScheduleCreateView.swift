//
//  GeneralScheduleCreateView.swift
//  On-Dot
//
//  Created by 현수 노트북 on 4/14/25.
//

import SwiftUI

struct GeneralScheduleCreateView: View {
    @StateObject private var viewModel = GeneralScheduleCreateViewModel()
    @State private var path = NavigationPath()
    
    private var isNextBUttonEnabled: Bool {
        (viewModel.selectedDate != nil || !viewModel.activeWeekdays.isEmpty) && viewModel.selectedTime != nil
    }
    
    var onClickBtnClose: () -> Void
    
    var body: some View {
        NavigationStack(path: $path) {
            ZStack {
                Color.gray900.ignoresSafeArea()
                
                VStack(spacing: 0) {
                    TopBar(image: "ic_close_white", onClickButton: { onClickBtnClose() })
                    
                    Spacer().frame(height: 24)
                    
                    StepProgressBar(totalStep: 2, currentStep: 1)
                    
                    Spacer().frame(height: 34)
                    
                    Text("스케줄 날짜와 시간을 선택해주세요.")
                        .font(OnDotTypo.titleMediumM)
                        .foregroundStyle(Color.gray0)
                    
                    Spacer().frame(height: 48)
                    
                    ScrollView {
                        RepeatSettingView(
                            isOn: $viewModel.isRepeatOn,
                            isChecked: $viewModel.isChecked,
                            activeCheckChip: viewModel.activeCheckChip,
                            activeWeekdays: viewModel.activeWeekdays,
                            onClickToggle: { viewModel.onClickToggle() },
                            onClickCheckTextChip: { index in viewModel.onClickTextCheckChip(index: index)},
                            onClickTextChip: { index in viewModel.onClickTextChip(index: index) },
                            onClickCheckBox: { viewModel.onClickCheckBox() }
                        )
                        
                        Spacer().frame(height: 20)
                        
                        DateTimeSettingView(
                            selectedDate: viewModel.selectedDate,
                            selectedTime: viewModel.selectedTime,
                            referenceDate: viewModel.referenceDate,
                            isActiveCalendar: viewModel.isActiveCalendar,
                            isActiveTimePicker: viewModel.isActiveTimePicker,
                            activeWeekdays: viewModel.activeWeekdays,
                            meridiem: $viewModel.meridiem,
                            hour: $viewModel.hour,
                            minute: $viewModel.minute,
                            onClickSelectedDateView: { viewModel.onClickSelectedDateView() },
                            onClickSelectedTimeView: { viewModel.onClickSelectedTimeView() },
                            increaseMonth: { viewModel.increaseMonth() },
                            decreaseMonth: { viewModel.decreaseMonth() },
                            onClickDate: { date in viewModel.onClickDate(date: date) },
                            updateSelectedTime: { viewModel.updateSelectedTime() }
                        )
                    }
                    .scrollIndicators(.hidden)
                    
                    Spacer().frame(height: 16)
                    
                    OnDotButton(
                        content: "다음",
                        action: {
                            if isNextBUttonEnabled {
                                path.append(GeneralSchedule.fromToSearch)
                            }
                        },
                        style: isNextBUttonEnabled ? .green500 : .gray300
                    )
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(.horizontal, 22)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .navigationDestination(for: GeneralSchedule.self) { view in
                switch view {
                case .fromToSearch:
                    FromToSearchView()
                        .environmentObject(viewModel)
                }
            }
        }
    }
}
