//
//  OnboardingView.swift
//  On-Dot
//
//  Created by 현수 노트북 on 4/17/25.
//

import SwiftUI

struct OnboardingView: View {
    @ObservedObject private var viewModel = OnboardingViewModel()
    
    @State private var isButtonEnabled: Bool = false
    @FocusState private var focusState: TimeFocusField?
    
    var body: some View {
        ZStack {
            Color.gray900.ignoresSafeArea().onTapGesture {
                focusState = nil
            }
            
            VStack(spacing: 0) {
                StepProgressBar(totalStep: viewModel.totalStep, currentStep: viewModel.currentStep)
                
                Spacer().frame(height: 34)
                
                switch viewModel.currentStep {
                case 1:
                    OnboardingStep1View(
                        hourText: $viewModel.hourText,
                        minuteText: $viewModel.minuteText,
                        focusField: $focusState
                    )
                default:
                    EmptyView()
                }
                
                Spacer()
                
                OnDotButton(
                    content: "다음",
                    action: {
                        if isButtonEnabled {
                            viewModel.onClickButton()
                        }
                    },
                    style: isButtonEnabled ? .gray300 : .green500
                )
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 22)
            .padding(.top, 77)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
}
