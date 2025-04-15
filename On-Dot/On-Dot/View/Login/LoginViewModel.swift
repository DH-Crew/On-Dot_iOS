//
//  LoginViewModel.swift
//  On-Dot
//
//  Created by 현수 노트북 on 4/14/25.
//

import SwiftUI

final class LoginViewModel: ObservableObject {
    private let authRepository: AuthRepository
    
    init(authRepository: AuthRepository = AuthRepositoryImpl()) {
        self.authRepository = authRepository
    }
    
    func kakaoLogin(token: String) async {
        do {
            let response = try await authRepository.login(provider: "KAKAO", accessToken: token)
            await MainActor.run {
                print("Login success: \(response)")
                KeychainManager.shared.saveToken(response.accessToken, for: "accessToken")
                KeychainManager.shared.saveToken(response.refreshToken, for: "refreshToken")
            }
        } catch {
            await MainActor.run {
                print("Login Error: \(error)")
            }
        }
    }
}
