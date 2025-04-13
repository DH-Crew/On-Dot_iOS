//
//  RepeatSettingView.swift
//  On-Dot
//
//  Created by 현수 노트북 on 4/14/25.
//

import SwiftUI

struct RepeatSettingView: View {
    @Binding var isOn: Bool
    @Binding var isChecked: Bool
    
    var activeCheckChip: Int?
    var activeWeekdays: Set<Int>
    
    var onClickToggle: () -> Void
    var onClickCheckTextChip: (Int) -> Void
    var onClickTextChip: (Int) -> Void
    var onClickCheckBox: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Text("반복")
                    .font(OnDotTypo.bodyLargeR1)
                    .foregroundStyle(Color.gray0)
                Spacer()
                OnDotToggle(isOn: $isOn, action: onClickToggle)
            }
            .padding(.horizontal, 20)
            
            if isOn {
                VStack(spacing: 0) {
                    Spacer().frame(height: 16)
                    
                    Rectangle().fill(Color.gray600).frame(maxWidth: .infinity).frame(height: 0.5).padding(.horizontal, 4)
                    
                    Spacer().frame(height: 16)
                    
                    HStack(spacing: 8) {
                        ForEach(RepeatType.allCases, id: \.rawValue) { repeatType in
                            CheckTextChip(
                                title: repeatType.title,
                                style: activeCheckChip == nil && activeWeekdays.isEmpty ? .normal : activeCheckChip == repeatType.rawValue ? .active : .inactive,
                                onClickChip: { onClickCheckTextChip(repeatType.rawValue) }
                            )
                        }
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    
                    Spacer().frame(height: 16)
                    
                    WeekdaySelector(
                        activeWeekdays: activeWeekdays,
                        onWeekdaySelected: onClickTextChip
                    )
                    .padding(.horizontal, 20)
                    
                    Spacer().frame(height: 16)
                    
                    Rectangle().fill(Color.gray600).frame(maxWidth: .infinity).frame(height: 0.5).padding(.horizontal, 4)
                    
                    Spacer().frame(height: 16)
                    
                    HStack {
                        Text("공휴일에는 울리지 않기")
                            .font(OnDotTypo.bodyMediumR)
                            .foregroundStyle(Color.gray200)
                        
                        Spacer()
                        
                        OnDotCheckBox(isChecked: $isChecked, action: onClickCheckBox)
                    }
                    .padding(.horizontal, 20)
                }
                .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(Color.gray700)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

struct WeekdaySelector: View {
    let activeWeekdays: Set<Int>
    let onWeekdaySelected: (Int) -> Void
    
    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<7) { index in
                TextChip(
                    title: AppConstants.weekdaySymbolsKR[index],
                    style: activeWeekdays.isEmpty ? .normal :
                           activeWeekdays.contains(index) ? .active : .inactive,
                    onClickChip: { onWeekdaySelected(index) }
                )
            }
            Spacer()
        }
    }
}
