//
//  QuickScheduleCreateView.swift
//  On-Dot
//
//  Created by 현수 노트북 on 5/18/25.
//

import SwiftUI
import Combine

struct QuickScheduleView: View {
    @ObservedObject private var viewModel = QuickScheduleCreateViewModel()
    
    @FocusState private var focusState: Bool
    
    var onClickCloseButton: () -> Void
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            Color.gray900.ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 0) {
                TopBar(
                    image: "ic_close_white",
                    onClickButton: onClickCloseButton
                )
                
                verticalSpacer(24)
                
                StepProgressBar(totalStep: viewModel.totalStep, currentStep: viewModel.currentStep)
                
                verticalSpacer(34)
                
                Text("일정 생성을 위해 구체적인\n날짜와 시간, 장소를 말해주세요.")
                    .font(OnDotTypo.titleMediumM)
                    .foregroundStyle(Color.gray0)
                    .multilineTextAlignment(.leading)
                
                verticalSpacer(16)
                
                Text("예시) 6월 13일 오후 7시까지 신촌역 2번 출구")
                    .font(OnDotTypo.bodyMediumR)
                    .foregroundStyle(Color.green300)
                
                verticalSpacer(40)
                
                SingleTextFieldView(
                    focusState: $focusState,
                    input: $viewModel.voiceInput,
                    isReadOnly: true
                )
                
                verticalSpacer(20)
                
                HStack(spacing: 8) {
                    OnDotCheckBox(isChecked: $viewModel.isChecked)
                    Text("집에서 출발해요")
                        .font(OnDotTypo.bodyLargeR1)
                        .foregroundStyle(Color.gray200)
                }
                
                Spacer()
                
                HStack {
                    Text(viewModel.voiceInputPreview)
                        .font(OnDotTypo.titleSmallSB)
                        .foregroundStyle(Color.gray400)
                        .multilineTextAlignment(.leading)
                    
                    if viewModel.isRecording {
                        LoadingDotsView()
                    }
                }
                
                verticalSpacer(45)
                
                HStack {
                    Spacer()
                    Image(viewModel.isRecording ? "ic_voice_input_active" : "ic_voice_input_inactive")
                        .onTapGesture {
                            viewModel.toggleSTT()
                        }
                    Spacer()
                }
                
                verticalSpacer(61)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.horizontal, 22)
        }
    }
    
    @ViewBuilder
    private func verticalSpacer(_ value: CGFloat) -> some View {
        Spacer().frame(height: value)
    }
}

struct LoadingDotsView: View {
    @State private var currentDot: Int = 0
    private let dotCount = 3
    private let animationDuration = 0.4
    @State private var timer: Timer?
    
    var body: some View {
        HStack(spacing: 4) {
            ForEach(0..<dotCount, id: \.self) { index in
                Circle()
                    .fill(Color.gray400)
                    .frame(width: 6, height: 6)
                    .opacity(currentDot == index ? 1.0 : 0.3)
            }
        }
        .onAppear {
            startAnimating()
        }
        .onDisappear {
            stopAnimating()
        }
    }
    
    private func startAnimating() {
        timer = Timer.scheduledTimer(withTimeInterval: animationDuration, repeats: true) { _ in
            DispatchQueue.main.async {
                withAnimation(.easeInOut(duration: animationDuration)) {
                    currentDot = (currentDot + 1) % dotCount
                }
            }
        }
    }
    
    private func stopAnimating() {
        timer?.invalidate()
        timer = nil
    }
}
