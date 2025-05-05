//
//  ContentView.swift
//  On-Dot
//
//  Created by 현수 노트북 on 4/2/25.
//

import SwiftUI
import KakaoSDKAuth

struct ContentView: View {
    @StateObject private var router = AppRouter()
    
    var body: some View {
        ZStack {
            Color.gray900.ignoresSafeArea()
            
            switch router.state {
            case .splash:
                SplashView(onSplashCompleted: {
                    router.state = .auth
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
                    onOnboardingCompleted: { router.state = .main }
                )
            case .main:
                MainView(
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
                    onPreparationStarted: { router.state = .splash }
                )
            case .departure:
                DepartureAlarmRingView(
                    
                )
            default:
                Color.clear
            }
        }
        .onAppear {
            NotificationCenter.default.addObserver(forName: .didReceivePush, object: nil, queue: .main) { notification in
                if let userInfo = notification.userInfo {
                    router.handleNotificationPayload(userInfo)
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

