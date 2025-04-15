//
//  LoginView.swift
//  On-Dot
//
//  Created by 현수 노트북 on 4/14/25.
//

import SwiftUI
import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser

struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()
    
    var onLoginSuccess: () -> Void
    
    var body: some View {
        ZStack {
            Color.gray900.ignoresSafeArea()
            
            VStack {
                Spacer()
                
                OnDotButton(
                    content: "카카오 로그인",
                    action: {
                        if UserApi.isKakaoTalkLoginAvailable() {
                            loginWithKaKaoApp()
                        } else {
                            // 앱 미설치 시 계정 로그인
                            loginWithKakaoAccount()
                        }
                    },
                    style: .green500
                )
                .padding(.bottom, 20)
            }
            .padding(.horizontal, 22)
        }
        .onChange(of: viewModel.isLoginSuccessful) { newValue in
            if newValue {
                onLoginSuccess()
            }
        }
    }
    
    private func loginWithKaKaoApp() {
        UserApi.shared.loginWithKakaoTalk { (oauthToken, error) in
            if let error = error {
                print(error)
                loginWithKakaoAccount()
            } else {
                if let token = oauthToken {
                    Task {
                        await viewModel.kakaoLogin(token: token.accessToken)
                    }
                }
            }
        }
    }
    
    private func loginWithKakaoAccount() {
        UserApi.shared.loginWithKakaoAccount { (oauthToken, error) in
            if let error = error {
                print(error)
            } else {
                print("loginWithKakaoAccount() success")
                if let token = oauthToken {
                    Task {
                        await viewModel.kakaoLogin(token: token.accessToken)
                    }
                }
            }
        }
    }
}
