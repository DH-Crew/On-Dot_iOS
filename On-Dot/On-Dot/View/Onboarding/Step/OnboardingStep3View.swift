//
//  OnboardingStep3View.swift
//  On-Dot
//
//  Created by 현수 노트북 on 4/23/25.
//

import SwiftUI

struct OnboardingStep3View: View {
    @StateObject var viewModel: OnboardingViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if viewModel.internalStep == 1 {
                SoundSettingsView(
                    selectedCategory: $viewModel.selectedCategory,
                    selectedVolume: $viewModel.selectedVolume,
                    alarmSoundList: viewModel.alarmLibrary[viewModel.selectedCategory] ?? [],
                    onClickToggle: { newValue in viewModel.isMuteMode = newValue },
                    onSoundSelected: { newValue in
                        viewModel.selectedSound = newValue
                        AlarmPlayer.shared.stop()
                        AlarmPlayer.shared.play(soundFileName: newValue.fileName, numberOfLoops: 0)
                    }
                )
            } else {
                AlarmDelaySettingsView(
                    selectedInterval: $viewModel.selectedInterval,
                    selectedRepeatCount: $viewModel.selectedRepeatCount,
                    intervalList: viewModel.intervalList,
                    repeatCountList: viewModel.repeatCountList,
                    onClickToggle: { newValue in viewModel.isDelayMode = newValue }
                )
            }
        }
    }
}

