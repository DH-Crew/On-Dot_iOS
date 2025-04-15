//
//  AuthRepositoryImpl.swift
//  On-Dot
//
//  Created by 현수 노트북 on 4/14/25.
//

final class AuthRepositoryImpl: AuthRepository {
    func login(provider: String, accessToken: String) async throws -> JwtTokenModel {
        try await NetworkManager.shared.request(type: JwtTokenModel.self, api: .login(provider: provider, accessToken: accessToken))
    }
}
