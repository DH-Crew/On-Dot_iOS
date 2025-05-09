//
//  HomeView.swift
//  On-Dot
//
//  Created by 현수 노트북 on 4/12/25.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel: HomeViewModel = HomeViewModel()
    @State private var path = NavigationPath()
    let isSnoozed: Bool
    
    var navigateToGeneralScheduleCreateView: () -> Void
    
    var body: some View {
        NavigationStack(path: $path) {
            ZStack {
                Color.gray900.ignoresSafeArea()
                
                VStack(alignment: .leading, spacing: 0) {
                    Spacer().frame(height: 33)
                    
                    UserBadgeBannerView()
                    
                    Spacer().frame(height: 16)
                    
                    RemainingTimeView(alarmDate: viewModel.earliestAlarmAt)
                    
                    Spacer().frame(height: 36)
                    
                    ScheduleAlarmListView(
                        scheduleList: viewModel.scheduleList,
                        onClickToggle: { id, isOn in
                            Task {
                                await viewModel.updateScheduleAlarmEnabled(id: id, isOn: isOn)
                            }
                        },
                        onDelete: { id in
                            Task {
                                await viewModel.deleteSchedule(id: id)
                            }
                        },
                        onScheduleSelected: { id in
                            Task {
                                await MainActor.run { viewModel.editableScheduleId = id }
                                await viewModel.getScheduleDetail(id: id)
                                await MainActor.run { path.append(HomeViewDestination.edit) }
                            }
                        }
                    )
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(.horizontal, 22)
                
                ZStack {
                    if viewModel.isShrunk {
                        Color.gray900.opacity(0.8).onTapGesture {
                            withAnimation {
                                viewModel.isShrunk = false
                            }
                        }
                    }
                    
                    VStack(alignment: .trailing, spacing: 0) {
                        if viewModel.isShrunk { CreateScheduleMenu(onClickQuickSchedule: {}, onClickGeneralSchedule: { navigateToGeneralScheduleCreateView() }) }
                        
                        Spacer().frame(height: 15)
                        
                        AddScheduleButtonView(isShrunk: $viewModel.isShrunk, onClickButton: { viewModel.isShrunk.toggle() })
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                    .padding(.bottom, 20)
                    .padding(.trailing, 22)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea(.keyboard, edges: .bottom)
            .toast(isPresented: $viewModel.showDeleteCompletionToast, isDelete: true, minute: 0, dateTime: "", onClickBtnRevert: viewModel.restoreDeletedSchedule)
            .navigationDestination(for: HomeViewDestination.self) { view in
                switch view {
                case .edit:
                    ConfirmEditScheduleView(
                        scheduleTitle: $viewModel.editableSchedule.title,
                        lastFocusedField: $viewModel.lastFocusedField,
                        fromLocation: $viewModel.editableSchedule.departurePlace.title,
                        toLocation: $viewModel.editableSchedule.arrivalPlace.title,
                        isRepeatOn: $viewModel.editableSchedule.isRepeat,
                        isChecked: $viewModel.isChecked,
                        meridiem: $viewModel.meridiem,
                        hour: $viewModel.hour,
                        minute: $viewModel.minute,
                        formattedSelectedDate: viewModel.formattedDate,
                        formattedSelectedTime: viewModel.formattedTime,
                        selectedWeekdays: viewModel.activeWeekdays,
                        isConfirmMode: false,
                        departureAlarm: viewModel.editableSchedule.departureAlarm,
                        preparationAlarm: viewModel.editableSchedule.preparationAlarm,
                        activeCheckChip: viewModel.activeCheckChip,
                        selectedDate: viewModel.selectedDate,
                        selectedTime: viewModel.selectedTime,
                        referenceDate: viewModel.referenceDate,
                        onClickCreateButton: {
                            Task {
                                await viewModel.editSchedule()
                                await MainActor.run {
                                    path.removeLast()
                                }
                            }
                        },
                        onClickBackButton: { path.removeLast() },
                        onClickDeleteButton: {
                            Task {
                                await viewModel.deleteSchedule(id: viewModel.editableScheduleId)
                                viewModel.editableScheduleId = -1
                            }
                            path.removeLast()
                        },
                        onClickToggle: { viewModel.onClickToggle() },
                        onClickCheckTextChip: { index in viewModel.onClickTextCheckChip(index: index) },
                        onClickTextChip: { newValue in viewModel.onClickTextChip(index: newValue) },
                        increaseMonth: { viewModel.increaseMonth() },
                        decreaseMonth: { viewModel.decreaseMonth() },
                        onClickDate: { date in viewModel.onClickDate(date: date) },
                        updateSelectedTime: { viewModel.updateSelectedTime() }
                    )
                    .ignoresSafeArea(.keyboard, edges: .bottom)
                    .toolbar(.hidden, for: .tabBar)
                    .navigationBarBackButtonHidden(true)
                    .enableSwipeBack()
                }
            }
            .onAppear {
                Task {
                    await viewModel.getSchedules(isSnoozed: isSnoozed)
                }
            }
        }
    }
}

struct ScheduleAlarmListView: View {
    let scheduleList: [HomeScheduleInfo]
    
    var onClickToggle: (Int, Bool) -> Void
    var onDelete: (Int) -> Void
    var onScheduleSelected: (Int) -> Void = { _ in }
    
    var body: some View {
        ScrollView {
            LazyVStack {
                Image("ic_home_banner")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
                
                if scheduleList.isEmpty {
                    Spacer().frame(height: 120)
                    EmptyScheduleView()
                } else {
                    Spacer().frame(height: 24)
                    ForEach(scheduleList, id: \.id) { item in
                        SwipeableItemView(
                            item: item,
                            onClickToggle: { newValue in
                                onClickToggle(item.id, newValue)
                            },
                            onDelete: {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                    onDelete(item.id)
                                }
                            },
                            onItemSelected: onScheduleSelected
                        )
                        
                        Spacer().frame(height: 20)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity)
        .scrollIndicators(.hidden)
    }
}
