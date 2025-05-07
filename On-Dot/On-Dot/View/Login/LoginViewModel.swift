//
//  LoginViewModel.swift
//  On-Dot
//
//  Created by 현수 노트북 on 4/14/25.
//

import SwiftUI
import AuthenticationServices

final class LoginViewModel: NSObject, ObservableObject {
    private let authRepository: AuthRepository
    private let keyChainManager: KeychainManager
    
    @Published var isLoginSuccessful: Bool = false
    @Published var isNewUser: Bool = false
    
    init(
        authRepository: AuthRepository = AuthRepositoryImpl(),
        keyChainManager: KeychainManager = KeychainManager.shared
    ) {
        self.authRepository = authRepository
        self.keyChainManager = keyChainManager
    }
    
    // MARK: - 카카오 로그인
    func kakaoLogin(token: String) async {
        do {
            let response = try await authRepository.login(provider: "KAKAO", accessToken: token)
            await MainActor.run {
                print("Login success: \(response)")
                keyChainManager.saveToken(response.accessToken, for: "accessToken")
                keyChainManager.saveToken(response.refreshToken, for: "refreshToken")
                isLoginSuccessful = true
                isNewUser = !response.isOnboardingCompleted
            }
        } catch {
            await MainActor.run {
                print("Login Error: \(error)")
            }
        }
    }
    
    // MARK: - 애플 로그인 API 호출
    func appleLogin(token: String) async {
        do {
            let response = try await authRepository.login(provider: "APPLE", accessToken: token)
            await MainActor.run {
                keyChainManager.saveToken(response.accessToken, for: "accessToken")
                keyChainManager.saveToken(response.refreshToken, for: "refreshToken")
                isNewUser = !response.isOnboardingCompleted
                isLoginSuccessful = true
            }
        } catch {
            await MainActor.run {
                print("Apple Login Error:", error)
            }
        }
    }
}

// MARK: – ASAuthorizationControllerDelegate & PresentationContextProviding
extension LoginViewModel: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    
    // 1) 인증 성공 시 호출
    func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithAuthorization authorization: ASAuthorization
    ) {
        guard let appleID = authorization.credential as? ASAuthorizationAppleIDCredential
        else {
            print("AppleIDCredential or token parsing failed")
            return
        }
        
        guard let authorizationCode = appleID.authorizationCode else { return }
        guard let authorizationCodeString = String(data: authorizationCode, encoding: .utf8) else { return }
        
        let fullName = appleID.fullName
        let email = appleID.email
        
        // 받은 토큰으로 서버 로그인
        Task {
            await appleLogin(token: authorizationCodeString)
        }
    }
    
    // 2) 인증 실패 시 호출
    func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithError error: Error
    ) {
        print("애플 로그인 인증 실패:", error)
    }
    
    // 3) ASAuthorizationController 가 표시될 윈도우 앵커
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return UIApplication.shared.connectedScenes
            .compactMap { ($0 as? UIWindowScene)?.keyWindow }
            .first ?? ASPresentationAnchor()
    }
}
