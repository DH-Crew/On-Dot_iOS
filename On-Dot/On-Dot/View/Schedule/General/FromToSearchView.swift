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
                        lastFocusedField: $viewModel.lastFocuesdField,
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
                
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 16) {
                        ForEach(viewModel.searchResult) { location in
                            LocationSearchItemView(keyword: viewModel.currentKeyword, title: location.title, detail: location.roadAddress)
                                .onTapGesture {
                                    viewModel.onClickLocationItem(location: location)
                                }
                            Rectangle().fill(Color.gray800).frame(maxWidth: .infinity).frame(height: 0.5)
                        }
                    }
                    .padding(.horizontal, 22)
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    focusedField = nil
                }
                .gesture(
                    DragGesture()
                        .onChanged { _ in
                            focusedField = nil
                        }
                )
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear {
            focusedField = .from
        }
        .onChange(of: viewModel.isFromLocationSelected) { _ in
            checkIfLocationSelectionCompleted()
        }
        .onChange(of: viewModel.isToLocationSelected) { _ in
            checkIfLocationSelectionCompleted()
        }
    }
    
    private func checkIfLocationSelectionCompleted() {
        if viewModel.isFromLocationSelected && viewModel.isToLocationSelected {
            isLocationSelected()
        }
    }
}
