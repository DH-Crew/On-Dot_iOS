//
//  Router.swift
//  On-Dot
//
//  Created by 현수 노트북 on 4/14/25.
//

import Foundation
import Alamofire

enum Router: URLRequestConvertible {

    var method: HTTPMethod {
        switch self {
        }
    }

    var path: String {
        switch self {
        }
    }

    var headers: HTTPHeaders {
        var headers: HTTPHeaders = ["Content-Type": "application/json"]
//        if let token = KeychainManager.shared.readToken(for: "accessToken") {
//            headers.add(name: "Authorization", value: "Bearer \(token)")
//        }
        return headers
    }

    var body: Parameters? {
        switch self {
        default: return nil
        }
    }

    func asURLRequest() throws -> URLRequest {
        guard let url = URL(string: BASE_URL + path) else { throw RequestError.invalidURL }
        var request = URLRequest(url: url)
        request.method = method
        request.headers = headers
        if let body = body {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        }
        return request
    }
}

extension Encodable {
    func asDictionary() throws -> [String: Any] {
        let data = try JSONEncoder().encode(self)
        let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
        guard let result = dictionary as? [String: Any] else {
            throw RequestError.decode
        }
        return result
    }
}
