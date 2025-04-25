//
//  AlarmDelaySettingsView.swift
//  On-Dot
//
//  Created by 현수 노트북 on 4/26/25.
//

import SwiftUI

struct AlarmDelaySettingsView: View {
    @State private var isOn: Bool = false
    
    let intervalList: [AlarmInterval]
    let repeatCountList: [RepeatCount]
    
    var onClickBtnBack: () -> Void
    var onClickToggle: (Bool) -> Void
    var onIntervalSelected: (AlarmInterval) -> Void
    var onRepeatCountSelected: (RepeatCount) -> Void
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            Color.gray900.ignoresSafeArea()
            
            VStack(spacing: 0) {
                TopBar(
                    title: "알람 미루기",
                    image: "ic_back",
                    onClickButton: onClickBtnBack
                )
                
                Spacer().frame(height: 24)
                
                ScrollView {
                    HStack {
                        Text("알람 미루기")
                            .font(OnDotTypo.bodyLargeR1)
                            .foregroundStyle(Color.gray0)
                        
                        Spacer()
                        
                        OnDotToggle(isOn: $isOn, action: { onClickToggle(isOn) })
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)
                    .background(Color.gray700)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    
                    Spacer().frame(height: 20)
                    
                    if isOn {
                        VStack(spacing: 20) {
                            AlarmIntervalView(
                                intervalList: intervalList,
                                onIntervalSelected: onIntervalSelected
                            )
                            
                            AlarmRepeatCountView(
                                repeatCountList: repeatCountList,
                                onRepeatCountSelected: onRepeatCountSelected
                            )
                        }
                    }
                    
                    Spacer()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.horizontal, 22)
        }
    }
}

private struct AlarmIntervalView: View {
    @State private var selectedDelay: AlarmInterval = AlarmInterval.one
    
    let intervalList: [AlarmInterval]
    
    var onIntervalSelected: (AlarmInterval) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("간격")
                .font(OnDotTypo.bodyLargeR1)
                .foregroundStyle(Color.gray0)
                .padding(.horizontal, 20)
            
            Spacer().frame(height: 16)
            
            Rectangle().fill(Color.gray600).frame(height: 0.5).frame(maxWidth: .infinity).padding(.horizontal, 4)
            
            Spacer().frame(height: 16)
            
            OnDotRadioGroup(
                items: intervalList,
                label: { newValue in newValue.displayName },
                callback: { onIntervalSelected(selectedDelay) },
                selected: $selectedDelay
            )
            .padding(.horizontal, 20)
        }
        .padding(.vertical, 16)
        .frame(maxWidth: .infinity)
        .background(Color.gray700)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

private struct AlarmRepeatCountView: View {
    @State private var selectedCount: RepeatCount = .infinite
    
    let repeatCountList: [RepeatCount]
    
    var onRepeatCountSelected: (RepeatCount) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("횟수")
                .font(OnDotTypo.bodyLargeR1)
                .foregroundStyle(Color.gray0)
                .padding(.horizontal, 20)
            
            Spacer().frame(height: 16)
            
            Rectangle().fill(Color.gray600).frame(height: 0.5).frame(maxWidth: .infinity).padding(.horizontal, 4)
            
            Spacer().frame(height: 16)
            
            OnDotRadioGroup(
                items: repeatCountList,
                label: { newValue in newValue.displayName },
                callback: { onRepeatCountSelected(selectedCount) },
                selected: $selectedCount
            )
            .padding(.horizontal, 20)
        }
        .padding(.vertical, 16)
        .frame(maxWidth: .infinity)
        .background(Color.gray700)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
