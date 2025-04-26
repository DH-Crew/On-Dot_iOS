//
//  AuthRepository.swift
//  On-Dot
//
//  Created by 현수 노트북 on 4/14/25.
//

protocol AuthRepository {
    func login(provider: String, accessToken: String) async throws -> LoginResponse
}
