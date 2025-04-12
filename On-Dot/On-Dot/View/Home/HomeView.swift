//
//  HomeView.swift
//  On-Dot
//
//  Created by 현수 노트북 on 4/12/25.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel: HomeViewModel = HomeViewModel()
    
    var body: some View {
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
                    }
                )
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.horizontal, 22)
            
            AddScheduleButtonView(isShrunk: $viewModel.isShrunk, onClickButton: { viewModel.isShrunk.toggle() })
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                .padding(.bottom, 20)
                .padding(.trailing, 22)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .toast(isPresented: $viewModel.showDeleteCompletionToast, isDelete: true, minute: 0, dateTime: "", onClickBtnRevert: viewModel.restoreDeletedSchedule)
    }
}

struct ScheduleAlarmListView: View {
    let scheduleList: [ScheduleModel]
    
    var onClickToggle: (Int, Bool) -> Void
    var onDelete: (Int) -> Void
    
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
                            }
                        )
                    }
                }
            }
        }
        .frame(maxWidth: .infinity)
        .scrollIndicators(.hidden)
    }
}
