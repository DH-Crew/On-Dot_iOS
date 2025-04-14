//
//  RequestError.swift
//  On-Dot
//
//  Created by 현수 노트북 on 4/14/25.
//

enum RequestError: Error {
    case decode
    case invalidURL
    case noResponse
    case unauthorized
    case unexpectedStatusCode(Int)
    case unknown
}
