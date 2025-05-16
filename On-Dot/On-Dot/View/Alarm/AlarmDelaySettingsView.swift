//
//  AlarmDelaySettingsView.swift
//  On-Dot
//
//  Created by 현수 노트북 on 4/26/25.
//

import SwiftUI

struct AlarmDelaySettingsView: View {
    @State private var isOn: Bool = false
    @Binding var selectedInterval: AlarmInterval
    @Binding var selectedRepeatCount: RepeatCount
    
    let intervalList: [AlarmInterval]
    let repeatCountList: [RepeatCount]
    
    var onClickToggle: (Bool) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 0) {
                Text("알람의 미루기")
                    .font(OnDotTypo.titleMediumM)
                    .foregroundColor(Color.green500)
                Text("를 설정해 주세요.")
                    .font(OnDotTypo.titleMediumM)
                    .foregroundColor(Color.gray0)
            }
            
            Spacer().frame(height: 16)
            
            Text("추후에 마이페이지에서 수정할 수 있어요.")
                .font(OnDotTypo.bodyMediumR)
                .foregroundStyle(Color.green300)
            
            Spacer().frame(height: 40)
            
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
                            selectedInterval: $selectedInterval,
                            intervalList: intervalList
                        )
                        
                        AlarmRepeatCountView(
                            selectedRepeatCount: $selectedRepeatCount,
                            repeatCountList: repeatCountList
                        )
                    }
                }
                
                Spacer()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

private struct AlarmIntervalView: View {
    @Binding var selectedInterval: AlarmInterval
    
    let intervalList: [AlarmInterval]
    
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
                selected: $selectedInterval
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
    @Binding var selectedRepeatCount: RepeatCount
    
    let repeatCountList: [RepeatCount]
    
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
                selected: $selectedRepeatCount
            )
            .padding(.horizontal, 20)
        }
        .padding(.vertical, 16)
        .frame(maxWidth: .infinity)
        .background(Color.gray700)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
