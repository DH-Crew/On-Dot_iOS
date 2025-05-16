//
//  ContentView.swift
//  On-Dot
//
//  Created by 현수 노트북 on 4/2/25.
//

import SwiftUI
import KakaoSDKAuth

struct ContentView: View {
    @EnvironmentObject var router: AppRouter
    
    var body: some View {
        ZStack {
            Color.gray900.ignoresSafeArea()
            
            switch router.state {
            case .splash:
                SplashView(onSplashCompleted: { skipLogin in
                    if skipLogin {
                        router.state = .main
                    } else {
                        router.state = .auth
                    }
                })
            case .auth:
                LoginView(
                    onLoginSuccess: { isNewUser in
                        if isNewUser {
                            router.state = .onboarding
                        } else {
                            router.state = .main
                        }
                    }
                )
            case .onboarding:
                OnboardingView(
                    onOnboardingCompleted: router.onOnboardingCompleted
                )
            case .main:
                MainView(
                    isSnoozed: router.isSnoozed,
                    fromOnboarding: router.fromOnboarding,
                    convertAppState: { newState in
                        router.state = newState
                    }
                )
            case .general:
                GeneralScheduleCreateView(
                    onClickBtnClose: { router.state = .main }
                )
            case .preparation:
                PreparationAlarmRingView(
                    isSnoozed: router.isSnoozed,
                    schedule: router.schedule,
                    interval: router.interval,
                    repeatCount: router.repeatCount,
                    type: router.alarmType,
                    onPreparationStarted: router.onPreparationStarted,
                    onClickDelayButton: router.onClickDelayButton
                )
            case .departure:
                DepartureAlarmRingView(
                    isSnoozed: router.isSnoozed,
                    schedule: router.schedule,
                    interval: router.interval,
                    repeatCount: router.repeatCount,
                    type: router.alarmType,
                    mapType: router.mapType,
                    onClickNavigateButton: router.onClickNavigateButton,
                    onClickDelayButton: router.onClickDelayButton
                )
            default:
                Color.clear
            }
            
            if router.showPreparationStartAnimation {
                ZStack {
                    Color.gray900.ignoresSafeArea()
                    
                    LottieView(name: "preparation_start", loopMode: .playOnce, onCompleted: { router.showPreparationStartAnimation = false })
                }
            }
        }
        .onOpenURL { url in
            print("Received URL: \(url)")
            if AuthApi.isKakaoTalkLoginUrl(url) {
                _ = AuthController.handleOpenUrl(url: url, options: [:])
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

