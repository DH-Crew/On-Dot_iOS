//
//  Router.swift
//  On-Dot
//
//  Created by 현수 노트북 on 4/14/25.
//

import Foundation
import Alamofire

enum Router: URLRequestConvertible {
    
    // MARK: Auth
    case login(provider: String, accessToken: String)

    // MARK: Location
    case searchPlace(query: String)
    
    // MARK: Schedule
    case createSchedule(schedule: ScheduleRequest)

    var method: HTTPMethod {
        switch self {
        case .login, .createSchedule: .post
        case .searchPlace: .get
        }
    }

    var path: String {
        switch self {
        // MARK: Auth
        case .login: "/auth/login/oauth"
        
        // MARK: Location
        case .searchPlace: "/places/search"
            
        // MARK: Schedule
        case .createSchedule: "/schedules"
        }
    }

    var headers: HTTPHeaders {
        var headers: HTTPHeaders = ["Content-Type": "application/json"]
        if let token = KeychainManager.shared.readToken(for: "accessToken") {
            headers.add(name: "Authorization", value: "Bearer \(token)")
        }
        return headers
    }

    var body: Parameters? {
        switch self {
        default: return nil
        }
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .login(let provider, let accessToken):
            return [
                URLQueryItem(name: "provider", value: provider),
                URLQueryItem(name: "access_token", value: accessToken)
            ]
        case .searchPlace(let query):
            return [
                URLQueryItem(name: "query", value: query)
            ]
        default: return nil
        }
    }

    func asURLRequest() throws -> URLRequest {
        var url: URL

        if let queryItems = queryItems {
            guard var components = URLComponents(string: BASE_URL + path) else {
                throw RequestError.invalidURL
            }
            components.queryItems = queryItems
            guard let fullURL = components.url else {
                throw RequestError.invalidURL
            }
            url = fullURL
        } else {
            guard let simpleURL = URL(string: BASE_URL + path) else {
                throw RequestError.invalidURL
            }
            url = simpleURL
        }
        
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
