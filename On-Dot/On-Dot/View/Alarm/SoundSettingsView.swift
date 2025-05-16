//
//  SoundSettingsView.swift
//  On-Dot
//
//  Created by 현수 노트북 on 4/23/25.
//

import SwiftUI

struct SoundSettingsView: View {
    @State private var isOn: Bool = false
    
    @Binding var selectedCategory: AlarmCategory
    @Binding var selectedVolume: Float
    let alarmSoundList: [AlarmSound]
    
    var onClickToggle: (Bool) -> Void
    var onSoundSelected: (AlarmSound) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 0) {
                Text("알람의 초기 사운드")
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
            
            HStack {
                Text("무음")
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
            
            Group {
                Spacer().frame(height: 20)
                
                CategoryListView(selectedCategory: $selectedCategory)
                
                Spacer().frame(height: 20)
                
                SoundListView(alarmSoundList: alarmSoundList, onSoundSelected: onSoundSelected)
                
                Spacer().frame(height: 20)
                
                VolumeSliderView(
                    volume: $selectedVolume
                )
                
                Spacer()
            }
            .dimmed(isOn)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

private struct CategoryListView: View {
    @Binding var selectedCategory: AlarmCategory
    
    var body: some View {
        HStack(spacing: 10) {
            categoryItemView(categoryType: .category1)
            categoryItemView(categoryType: .category2)
        }
    }
    
    @ViewBuilder
    private func categoryItemView(
        categoryType: AlarmCategory
    ) -> some View {
        Text(categoryType.displayName)
            .font(OnDotTypo.bodyMediumM)
            .foregroundStyle(selectedCategory == categoryType ? Color.green500 : Color.gray0)
            .padding(.vertical, 11)
            .padding(.horizontal, 16)
            .background(Color.gray700)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .onTapGesture {
                selectedCategory = categoryType
            }
    }
}

private struct SoundListView: View {
    @State private var selectedSound: AlarmSound = AlarmSound(name: "", fileName: "", ringTone: "")
    
    let alarmSoundList: [AlarmSound]
    
    var onSoundSelected: (AlarmSound) -> Void
    
    var body: some View {
        OnDotRadioGroup(
            items: alarmSoundList,
            label: { item in item.name },
            callback: { onSoundSelected(selectedSound) },
            selected: $selectedSound
        )
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.gray700)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

private struct VolumeSliderView: View {
    @Binding var volume: Float

    var body: some View {
        HStack {
            Image("ic_sound")
                .resizable()
                .frame(width: 24, height: 24)
            
            OnDotSlider(
                value: $volume,
                minimumValue: 0.0,
                maximumValue: 1.0,
                thumbSize: CGSize(width: 12, height: 12)
            )
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(Color.gray700)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .onChange(of: volume) { newValue in
            AlarmPlayer.shared.setVolume(newValue)
        }
    }
}
