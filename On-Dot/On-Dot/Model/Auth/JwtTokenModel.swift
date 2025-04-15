//
//  JwtTokenModel.swift
//  On-Dot
//
//  Created by 현수 노트북 on 4/14/25.
//

struct JwtTokenModel: Codable {
    let accessToken: String
    let refreshToken: String
}
