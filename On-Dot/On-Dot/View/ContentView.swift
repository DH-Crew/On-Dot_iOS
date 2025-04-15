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
                    onLoginSuccess: { router.state = .main }
                )
            case .main:
                NavigationStack {
                    MainView(
                        convertAppState: { newState in
                            router.state = newState
                        }
                    )
                }
            case .general:
                NavigationStack {
                    GeneralScheduleCreateView(
                        onClickBtnClose: { router.state = .main }
                    )
                }
            default:
                Color.clear
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

