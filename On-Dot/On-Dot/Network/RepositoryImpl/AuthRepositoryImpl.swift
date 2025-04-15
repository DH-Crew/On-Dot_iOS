//
//  AuthRepositoryImpl.swift
//  On-Dot
//
//  Created by 현수 노트북 on 4/14/25.
//

final class AuthRepositoryImpl: AuthRepository {
    private let networkManager: NetworkManager
    
    init(networkManager: NetworkManager = NetworkManager.shared) {
        self.networkManager = networkManager
    }
    
    func login(provider: String, accessToken: String) async throws -> JwtTokenModel {
        try await networkManager.request(type: JwtTokenModel.self, api: .login(provider: provider, accessToken: accessToken))
    }
}
