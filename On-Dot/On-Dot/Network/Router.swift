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
    case createSchedule(schedule: ScheduleInfo)
    case getSchedules
    case deleteSchedule(scheduleId: Int)
    
    // MARK: Member
    case onboarding(onboardingRequest: OnboardingRequest)
    
    // MARK: Alarm
    case calculate(calculateRequest: CalculateRequest)

    // MARK: -
    var method: HTTPMethod {
        switch self {
        case .login, .createSchedule, .calculate: .post
        case .searchPlace, .getSchedules: .get
        case .onboarding: .put
        case .deleteSchedule: .delete
        }
    }

    var path: String {
        switch self {
        // MARK: Auth
        case .login: "/auth/login/oauth"
        
        // MARK: Location
        case .searchPlace: "/places/search"
            
        // MARK: Schedule
        case .createSchedule, .getSchedules: "/schedules"
        case .deleteSchedule(let scheduleId): "/schedules/\(scheduleId)"
            
        // MARK: Member
        case .onboarding: "/members/onboarding"
            
        // MARK: Alarm
        case .calculate: "/alarms/setting"
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
        case .onboarding(let request):
            return try? request.asDictionary()
        case .calculate(let request):
            return try? request.asDictionary()
        case .createSchedule(let request):
            return try? request.asDictionary()
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
