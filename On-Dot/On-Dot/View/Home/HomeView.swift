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
    
    var navigateToGeneralScheduleCreateView: () -> Void
    
    var body: some View {
        NavigationStack(path: $path) {
            ZStack {
                Color.gray900.ignoresSafeArea()
                
                VStack(alignment: .leading, spacing: 0) {
                    Spacer().frame(height: 33)
                    
                    UserBadgeBannerView()
                    
                    Spacer().frame(height: 16)
                    
                    RemainingTimeView(day: -1, hour: -1, minute: -1)
                    
                    Spacer().frame(height: 36)
                    
                    ScheduleAlarmListView(
                        scheduleList: viewModel.scheduleList,
                        onClickToggle: { id, isOn in
                            viewModel.updateScheduleAlarmEnabled(id: id, isOn: isOn)
                        },
                        onDelete: { id in
                            viewModel.deleteSchedule(id: id)
                        },
                        onScheduleSelected: { id in
                            // TODO: 일정 상세 조회 API 호출
                            path.append(HomeViewDestination.edit)
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
                        selectedDate: viewModel.formattedDate,
                        selectedTime: viewModel.formattedTime,
                        selectedWeekdays: Set(viewModel.editableSchedule.repeatDays),
                        isConfirmMode: false,
                        departureAlarm: viewModel.editableSchedule.departureAlarm,
                        preparationAlarm: viewModel.editableSchedule.preparationAlarm,
                        onClickCreateButton: { path.removeLast() },
                        onClickBackButton: { path.removeLast() },
                        onClickDeleteButton: {
                            path.removeLast()
                        }
                    )
                    .toolbar(.hidden, for: .tabBar)
                    .navigationBarBackButtonHidden(true)
                    .enableSwipeBack()
                }
            }
        }
    }
}

struct ScheduleAlarmListView: View {
    let scheduleList: [ScheduleModel]
    
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
                        .onTapGesture {
                            onScheduleSelected(item.id)
                        }
                        
                        Spacer().frame(height: 20)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity)
        .scrollIndicators(.hidden)
    }
}
