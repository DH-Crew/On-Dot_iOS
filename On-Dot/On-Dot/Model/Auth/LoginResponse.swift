//
//  LoginResponse.swift
//  On-Dot
//
//  Created by 현수 노트북 on 4/26/25.
//

struct LoginResponse: Codable {
    let accessToken: String
    let refreshToken: String
    let isOnboardingCompleted: Bool
}
