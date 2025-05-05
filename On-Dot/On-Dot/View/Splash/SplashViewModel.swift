//
//  SplashViewModel.swift
//  On-Dot
//
//  Created by 현수 노트북 on 5/5/25.
//

import SwiftUI

final class SplashViewModel: ObservableObject {
    private let authRepository: AuthRepository
    private let keychainManager: KeychainManager
    
    @Published var skipLogin: Bool = false
    
    init(
        authRepository: AuthRepository = AuthRepositoryImpl(),
        keychainManager: KeychainManager = KeychainManager.shared
    ) {
        self.authRepository = authRepository
        self.keychainManager = keychainManager
        
        Task {
            await refreshToken()
        }
    }
    
    func refreshToken() async {
        do {
            let response = try await authRepository.refreshToken()
            
            keychainManager.saveToken(response.accessToken, for: "accessToken")
            keychainManager.saveToken(response.refreshToken, for: "refreshToken")
            
            await MainActor.run {
                skipLogin = true
            }
        } catch {
            print("토큰 갱신 실패: \(error)")
        }
    }
}
