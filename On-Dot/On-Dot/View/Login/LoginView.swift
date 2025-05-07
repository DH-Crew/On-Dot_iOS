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
import AuthenticationServices

struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()
    
    var onLoginSuccess: (Bool) -> Void
    
    var body: some View {
        ZStack {
            Color.gray900.ignoresSafeArea()
            
            Color.gradientLogin
                .ignoresSafeArea()
                .padding(.top, 100)
            
            VStack(spacing: 0) {
                
                Image("ic_login")
                    .padding(.top, 189)
                
                Spacer()
                
                loginButton(
                    title: "카카오로 계속하기",
                    image: "ic_kakao",
                    foregroundColor: .gray900,
                    backgroundColor: Color(hex: 0xFFFAE100),
                    action: {
                        if UserApi.isKakaoTalkLoginAvailable() {
                            loginWithKaKaoApp()
                        } else {
                            // 앱 미설치 시 계정 로그인
                            loginWithKakaoAccount()
                        }
                    }
                )
                
                Spacer().frame(height: 16)
                
                loginButton(
                    title: "Apple로 계속하기",
                    image: "ic_apple",
                    foregroundColor: .gray0,
                    backgroundColor: .gray900,
                    action: loginWithApple
                )
                .padding(.bottom, 22)
            }
            .padding(.horizontal, 22)
        }
        .onChange(of: viewModel.isLoginSuccessful) { newValue in
            if newValue {
                onLoginSuccess(viewModel.isNewUser)
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
    
    // ASAuthorizationController를 띄우는 메서드
    private func loginWithApple() {
        // 애플 로그인 요청 객체, 여기에 원하는 정보를 설정할 수 있음
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]

        // 애플 로그인 과정을 처리할 컨트롤러 생성, 로그인 성공/실패를 받기 위한 델리게이트로 뷰모델 설정
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = viewModel        // LoginViewModel이 ASAuthorizationControllerDelegate 채택
        controller.presentationContextProvider = viewModel
        controller.performRequests()
    }
    
    @ViewBuilder
    private func loginButton(
        title: String,
        image: String,
        foregroundColor: Color,
        backgroundColor: Color,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            HStack(alignment: .center, spacing: 10) {
                Image(image)
                
                Text(title)
                    .font(OnDotTypo.titleSmallSB)
                    .foregroundStyle(foregroundColor)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 18)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(backgroundColor)
            )
        }
    }
}
