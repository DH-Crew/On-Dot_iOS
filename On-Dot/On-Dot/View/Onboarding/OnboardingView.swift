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
    
    var onOnboardingCompleted: () -> Void
    
    var body: some View {
        NavigationStack(path: $path) {
            ZStack(alignment: .top) {
                Color.black.ignoresSafeArea()
                
                Color.gray900.ignoresSafeArea().onTapGesture {
                    focusState = nil
                }
                
                if viewModel.currentStep > 1 {
                    TopBar(
                        image: "ic_back",
                        onClickButton: viewModel.onClickBackButton
                    )
                    .padding(.horizontal, 22)
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
                                    insertion: .move(edge: viewModel.isBackNavigation ? .leading : .trailing).combined(with: .opacity),
                                    removal: .move(edge: viewModel.isBackNavigation ? .trailing : .leading).combined(with: .opacity)
                                )
                            )
                        } else if viewModel.currentStep == 2 {
                            OnboardingStep2View(
                                address: viewModel.address,
                                onClickLocationSearchView: { showAddressWebView = true }
                            )
                            .transition(
                                .asymmetric(
                                    insertion: .move(edge: viewModel.isBackNavigation ? .leading : .trailing).combined(with: .opacity),
                                    removal: .move(edge: viewModel.isBackNavigation ? .trailing : .leading).combined(with: .opacity)
                                )
                            )
                        } else if viewModel.currentStep == 3 {
                            OnboardingStep3View(
                                viewModel: viewModel
                            )
                            .transition(
                                .asymmetric(
                                    insertion: .move(edge: viewModel.isBackNavigation ? .leading : .trailing).combined(with: .opacity),
                                    removal: .move(edge: viewModel.isBackNavigation ? .trailing : .leading).combined(with: .opacity)
                                )
                            )
                        } else if viewModel.currentStep == 4 {
                            OnboardingStep4View(
                                selectedItem: $viewModel.selectedExpectationItem,
                                gridItems: viewModel.gridItems
                            )
                            .transition(
                                .asymmetric(
                                    insertion: .move(edge: viewModel.isBackNavigation ? .leading : .trailing).combined(with: .opacity),
                                    removal: .move(edge: viewModel.isBackNavigation ? .trailing : .leading).combined(with: .opacity)
                                )
                            )
                        } else if viewModel.currentStep == 5 {
                            OnboardingStep5View(
                                selectedItem: $viewModel.selectedReasonItem,
                                reasonList: viewModel.reasonItems
                            )
                            .transition(
                                .asymmetric(
                                    insertion: .move(edge: viewModel.isBackNavigation ? .leading : .trailing).combined(with: .opacity),
                                    removal: .move(edge: viewModel.isBackNavigation ? .trailing : .leading).combined(with: .opacity)
                                )
                            )
                        }
                    }
                    .animation(.easeInOut, value: viewModel.currentStep)
                    
                    Spacer()
                    
                    OnDotButton(
                        content: "다음",
                        action: {
                            if viewModel.isNextButtonEnabled {
                                viewModel.onClickButton()
                            }
                        },
                        style: viewModel.isNextButtonEnabled ? .green500 : .gray300
                    )
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 22)
                .padding(.top, 77)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea(.keyboard, edges: .bottom)
            .onChange(of: viewModel.onboardingCompleted) { _ in
                if viewModel.onboardingCompleted { onOnboardingCompleted() }
            }
            .onChange(of: viewModel.currentStep) { _ in
                switch viewModel.currentStep {
                case 1:
                    isButtonEnabled = !viewModel.hourText.isEmpty || !viewModel.minuteText.isEmpty
                case 2:
                    isButtonEnabled = !viewModel.address.isEmpty
                case 3:
                    isButtonEnabled = (viewModel.isMuteMode || viewModel.selectedSound != nil) && (!viewModel.isDelayMode)
                case 4:
                    isButtonEnabled = viewModel.selectedExpectationItem != nil
                default:
                    isButtonEnabled = viewModel.selectedReasonItem != nil
                }
            }
            .fullScreenCover(isPresented: $showAddressWebView) {
                ZStack {
                    AddressWebView(isPresented: $showAddressWebView, address: $viewModel.address)
                    
                    VStack {
                        Spacer()
                        
                        Button(action: {
                            showAddressWebView = false
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .padding(.bottom, 100)
                                .foregroundColor(.gray)
                        }
                    }
                }
                .ignoresSafeArea(.keyboard, edges: .bottom)
            }
        }
    }
}
