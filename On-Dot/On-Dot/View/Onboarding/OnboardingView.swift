//
//  OnboardingView.swift
//  On-Dot
//
//  Created by 현수 노트북 on 4/17/25.
//

import SwiftUI

struct OnboardingView: View {
    @ObservedObject private var viewModel = OnboardingViewModel()
    
    @State private var path = NavigationPath()
    @State private var isButtonEnabled: Bool = false
    @State private var showAddressWebView: Bool = false
    @FocusState private var focusState: TimeFocusField?
    
    var body: some View {
        NavigationStack(path: $path) {
            ZStack {
                Color.black.ignoresSafeArea()
                
                Color.gray900.ignoresSafeArea().onTapGesture {
                    focusState = nil
                }
                
                VStack(spacing: 0) {
                    StepProgressBar(totalStep: viewModel.totalStep, currentStep: viewModel.currentStep)
                    
                    Spacer().frame(height: 34)
                    
                    ZStack {
                        if viewModel.currentStep == 1 {
                            OnboardingStep1View(
                                hourText: $viewModel.hourText,
                                minuteText: $viewModel.minuteText,
                                focusField: $focusState
                            )
                            .transition(
                                .asymmetric(
                                    insertion: .move(edge: .trailing).combined(with: .opacity),
                                    removal: .move(edge: .leading).combined(with: .opacity)
                                )
                            )
                        } else if viewModel.currentStep == 2 {
                            OnboardingStep2View(
                                address: viewModel.address,
                                onClickLocationSearchView: { showAddressWebView = true }
                            )
                            .transition(
                                .asymmetric(
                                    insertion: .move(edge: .trailing).combined(with: .opacity),
                                    removal: .move(edge: .leading).combined(with: .opacity)
                                )
                            )
                        } else if viewModel.currentStep == 3 {
                            OnboardingStep3View(
                                onClickButton: { type in
                                    switch type {
                                    case .sound:
                                        path.append(Onboarding.sound)
                                    case .delay:
                                        path.append(Onboarding.delay)
                                    }
                                }
                            )
                            .transition(
                                .asymmetric(
                                    insertion: .move(edge: .trailing).combined(with: .opacity),
                                    removal: .move(edge: .leading).combined(with: .opacity)
                                )
                            )
                        }
                    }
                    .animation(.easeInOut, value: viewModel.currentStep)
                    
                    Spacer()
                    
                    OnDotButton(
                        content: "다음",
                        action: {
                            if isButtonEnabled {
                                withAnimation {
                                    viewModel.onClickButton()
                                }
                            }
                        },
                        style: isButtonEnabled ? .green500 : .gray300
                    )
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 22)
                .padding(.top, 77)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea(.keyboard, edges: .bottom)
            .onChange(of: viewModel.hourText) { _ in
                isButtonEnabled = !viewModel.hourText.isEmpty || !viewModel.minuteText.isEmpty
            }
            .onChange(of: viewModel.minuteText) { _ in
                isButtonEnabled = !viewModel.hourText.isEmpty || !viewModel.minuteText.isEmpty
            }
            .onChange(of: viewModel.address) { _ in
                isButtonEnabled = !viewModel.address.isEmpty
            }
            .onChange(of: viewModel.currentStep) { _ in
                switch viewModel.currentStep {
                case 1:
                    isButtonEnabled = !viewModel.hourText.isEmpty || !viewModel.minuteText.isEmpty
                case 2:
                    isButtonEnabled = !viewModel.address.isEmpty
                default:
                    isButtonEnabled = false
                }
            }
            .fullScreenCover(isPresented: $showAddressWebView) {
                AddressWebView(isPresented: $showAddressWebView, address: $viewModel.address)
            }
            .navigationDestination(for: Onboarding.self) { view in
                switch view {
                case .sound: 
                    SoundSettingsView(
                        selectedCategory: $viewModel.selectedCategory,
                        selectedVolume: $viewModel.selectedVolume,
                        alarmSoundList: viewModel.alarmLibrary[viewModel.selectedCategory]!,
                        onClickBtnBack: {
                            path.removeLast()
                        },
                        onClickToggle: { newValue in viewModel.isMuteMode = newValue },
                        onSoundSelected: { newValue in
                            viewModel.selectedSound = newValue
                            AlarmPlayer.shared.play(soundFileName: newValue.fileName, numberOfLoops: 0)
                        }
                    )
                    .navigationBarBackButtonHidden(true)
                    .enableSwipeBack()
                    .onDisappear {
                        AlarmPlayer.shared.stop()
                    }
                case .delay:
                    AlarmDelaySettingsView(
                        intervalList: viewModel.intervalList,
                        repeatCountList: viewModel.repeatCountList,
                        onClickBtnBack: { path.removeLast() },
                        onClickToggle: { newValue in viewModel.isDelayMode = newValue },
                        onIntervalSelected: { newValue in viewModel.selectedInterval = newValue },
                        onRepeatCountSelected: { newValue in viewModel.selectedRepeatCount = newValue }
                    )
                    .navigationBarBackButtonHidden(true).enableSwipeBack()
                @unknown default:
                    EmptyView()
                }
            }
        }
    }
}
