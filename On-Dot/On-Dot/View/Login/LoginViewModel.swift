//
//  LoginViewModel.swift
//  On-Dot
//
//  Created by 현수 노트북 on 4/14/25.
//

import SwiftUI

final class LoginViewModel: ObservableObject {
    private let authRepository: AuthRepository
    private let keyChainManager: KeychainManager
    
    @Published var isLoginSuccessful: Bool = false
    
    init(
        authRepository: AuthRepository = AuthRepositoryImpl(),
        keyChainManager: KeychainManager = KeychainManager.shared
    ) {
        self.authRepository = authRepository
        self.keyChainManager = keyChainManager
    }
    
    func kakaoLogin(token: String) async {
        do {
            let response = try await authRepository.login(provider: "KAKAO", accessToken: token)
            await MainActor.run {
                print("Login success: \(response)")
                keyChainManager.saveToken(response.accessToken, for: "accessToken")
                keyChainManager.saveToken(response.refreshToken, for: "refreshToken")
                isLoginSuccessful = true
            }
        } catch {
            await MainActor.run {
                print("Login Error: \(error)")
            }
        }
    }
}
