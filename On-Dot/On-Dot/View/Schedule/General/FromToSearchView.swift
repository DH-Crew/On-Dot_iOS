//
//  FromToSearchView.swift
//  On-Dot
//
//  Created by 현수 노트북 on 4/15/25.
//

import SwiftUI

struct FromToSearchView: View {
    @EnvironmentObject var viewModel: GeneralScheduleCreateViewModel
    
    @FocusState private var focusedField: FocusField?
    
    let selectedDate: String?
    let selectedTime: String
    
    var onClickBack: () -> Void
    var isLocationSelected: () -> Void
    
    var body: some View {
        ZStack {
            Color.gray900.ignoresSafeArea().onTapGesture {
                focusedField = nil
            }
            
            VStack(alignment: .leading, spacing: 0) {
                VStack(alignment: .leading, spacing: 0) {
                    TopBar(image: "ic_back", onClickButton: onClickBack)
                    
                    Spacer().frame(height: 24)
                    
                    StepProgressBar(totalStep: 2, currentStep: 2)
                    
                    Spacer().frame(height: 34)
                    
                    Text("출발지와 목적지를 알려주세요")
                        .font(OnDotTypo.titleMediumM)
                        .foregroundStyle(Color.gray0)
                    
                    Spacer().frame(height: 48)
                    
                    SelectedDateTimeView(
                        selectedDate: selectedDate,
                        selectedTime: selectedTime,
                        selectedWeekdays: viewModel.activeWeekdays
                    )
                    
                    Spacer().frame(height: 20)
                    
                    FromToLocationView(
                        fromLocation: $viewModel.fromLocation,
                        toLocation: $viewModel.toLocation,
                        lastFocusedField: $viewModel.lastFocusedField,
                        focusedField: $focusedField,
                        onValueChanged: { newValue in
                            viewModel.currentKeyword = newValue
                            Task {
                                await viewModel.onValueChanged(newValue: newValue)
                            }
                        },
                        onClickClose: { field in
                            viewModel.onClickClose(field: field)
                        }
                    )
                    
                    Spacer().frame(height: 24)
                }
                .padding(.horizontal, 22)
                
                Rectangle().fill(Color.gray800).frame(maxWidth: .infinity).frame(height: 8)
                
                Spacer().frame(height: 20)
                
                if viewModel.searchResult.isEmpty {
                    Spacer().frame(height: 60)
                    
                    EmptySearchResultView()
                } else {
                    ScrollView {
                        LazyVStack(alignment: .leading, spacing: 16) {
                            ForEach(viewModel.searchResult) { location in
                                LocationSearchItemView(keyword: viewModel.currentKeyword, title: location.title, detail: location.roadAddress)
                                    .onTapGesture {
                                        if viewModel.lastFocusedField == .from {
                                            viewModel.selectedFromLocation = location
                                            print("selectedFromLocation: \(viewModel.selectedFromLocation)")
                                        } else if viewModel.lastFocusedField == .to {
                                            viewModel.selectedToLocation = location
                                            print("selectedToLocation: \(viewModel.selectedToLocation)")
                                        }
                                        
                                        viewModel.onClickLocationItem(location: location)
                                        focusedField = nil
                                    }
                                Rectangle().fill(Color.gray800).frame(maxWidth: .infinity).frame(height: 0.5)
                            }
                        }
                        .padding(.horizontal, 22)
                    }
                    .contentShape(Rectangle())
                    .simultaneousGesture(
                        DragGesture()
                            .onChanged { _ in
                                focusedField = nil
                            }
                    )
                }
                
                Spacer()
                
                OnDotButton(
                    content: "다음",
                    action: checkIfLocationSelectionCompleted,
                    style: viewModel.isFromLocationSelected && viewModel.isToLocationSelected ? .green500 : .gray300
                )
                .padding(.horizontal, 22)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
    
    private func checkIfLocationSelectionCompleted() {
        if viewModel.isFromLocationSelected && viewModel.isToLocationSelected {
            isLocationSelected()
        }
    }
}
