//
//  ApiResponse.swift
//  On-Dot
//
//  Created by 현수 노트북 on 4/14/25.
//

struct ApiResponse<T: Decodable>: Decodable {
    let isSuccess: Bool
    let message: String
    let result: T?
}
