//
//  ContentView.swift
//  On-Dot
//
//  Created by 현수 노트북 on 4/2/25.
//

import SwiftUI

struct ContentView: View {
    @State var isOn: Bool = false
    @State var isOnTrue: Bool = true
    @State var isChecked: Bool = false
    @State var isCheckedTrue: Bool = true
    @State var selectedInterval: AlarmInterval = .one
    @State var showDialog: Bool = false
    
    var body: some View {
        ZStack {
            Color.gray900
                .ignoresSafeArea()
            
            VStack(alignment: .center) {
                HStack(spacing: 10) {
                    OnDotButton(content: "버튼", action: {})
                }
                
                HStack(spacing: 10) {
                    OnDotToggle(isOn: $isOn)
                    OnDotToggle(isOn: $isOnTrue)
                }
                
                HStack(spacing: 10) {
                    OnDotCheckBox(isChecked: $isChecked)
                    OnDotCheckBox(isChecked: $isCheckedTrue)
                }
                
                HStack(spacing: 10) {
                    TextChip(title: "라벨", isActive: true)
                    TextChip(title: "라벨", isActive: false)
                }
                
                HStack(spacing: 10) {
                    CheckTextChip(title: "라벨", style: CheckTextChip.Style.active)
                    CheckTextChip(title: "라벨", style: CheckTextChip.Style.inactive)
                    CheckTextChip(title: "라벨", style: CheckTextChip.Style.normal)
                }
                
                HStack(spacing: 10) {
                    WeekDayChip(title: "일", style: WeekDayChip.Style.active)
                    WeekDayChip(title: "일", style: WeekDayChip.Style.inactive)
                    WeekDayChip(title: "일", style: WeekDayChip.Style.normal)
                }
                
                HStack {
                    OnDotRadioGroup(items: AlarmInterval.allCases, label: { $0.label }, selected: $selectedInterval)
                }
                
                HStack {
                    CreateScheduleMenu(onClickQuickSchedule: {}, onClickGeneralSchedule: {})
                }
            }
            .padding()
            
            if showDialog {
                OnDotDialog(
                    title: "변경 사항 삭제", content: "변경 사항을 저장하지 않고\n나가시겠어요?",
                    positiveButtonText: "나가기", negativeButtonText: "취소",
                    onClickBtnPositive: {}, onClickBtnNegative: {}, onDismissRequest: {}
                )
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    ContentView()
}
