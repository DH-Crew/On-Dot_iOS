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
    case logout
    case refresh

    // MARK: Location
    case searchPlace(query: String)
    
    // MARK: Schedule
    case createSchedule(schedule: ScheduleInfo)
    case getSchedules
    case deleteSchedule(scheduleId: Int)
    case getScheduleDetail(scheduleId: Int)
    case editSchedule(scheduleId: Int, schedule: ScheduleInfo)
    case updateAlarmEnabled(scheduleId: Int, request: AlarmEnabled)
    case parseSTT(request: STTRequest)
    
    // MARK: Member
    case onboarding(onboardingRequest: OnboardingRequest)
    case getHomeAddress
    case editHomeAddress(address: HomeAddressInfo)
    case withdrawal(request: WithdrawalRequest)
    case editMapProvider(request: MapProvider)
    
    // MARK: Alarm
    case calculate(calculateRequest: CalculateRequest)

    // MARK: -
    var method: HTTPMethod {
        switch self {
        case .login, .createSchedule, .calculate, .withdrawal, .logout, .refresh, .parseSTT: .post
        case .searchPlace, .getSchedules, .getScheduleDetail, .getHomeAddress: .get
        case .onboarding, .editSchedule: .put
        case .editHomeAddress, .editMapProvider, .updateAlarmEnabled: .patch
        case .deleteSchedule: .delete
        }
    }

    var path: String {
        switch self {
        // MARK: Auth
        case .login: "/auth/login/oauth"
        case .logout: "/auth/logout"
        case .refresh: "/auth/reissue"
        
        // MARK: Location
        case .searchPlace: "/places/search"
            
        // MARK: Schedule
        case .createSchedule, .getSchedules: "/schedules"
        case .deleteSchedule(let scheduleId), .getScheduleDetail(let scheduleId): "/schedules/\(scheduleId)"
        case .editSchedule(let scheduleId, _): "/schedules/\(scheduleId)"
        case .updateAlarmEnabled(let scheduleId, _): "/schedules/\(scheduleId)/alarm"
        case .parseSTT: "/schedules/nlp"
            
        // MARK: Member
        case .onboarding: "/members/onboarding"
        case .getHomeAddress, .editHomeAddress: "/members/home-address"
        case .withdrawal: "/members/deactivate"
        case .editMapProvider: "/members/map-provider"
            
        // MARK: Alarm
        case .calculate: "/alarms/setting"
        }
    }

    var headers: HTTPHeaders {
        var headers: HTTPHeaders = ["Content-Type": "application/json"]
        switch self {
        case .refresh:
            if let token = KeychainManager.shared.readToken(for: "refreshToken") {
                headers.add(name: "Authorization", value: "Bearer \(token)")
            }
        default:
            if let token = KeychainManager.shared.readToken(for: "accessToken") {
                headers.add(name: "Authorization", value: "Bearer \(token)")
            }
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
        case .editSchedule(_, let schedule):
            return try? schedule.asDictionary()
        case .editHomeAddress(let address):
            return try? address.asDictionary()
        case .withdrawal(let request):
            return try? request.asDictionary()
        case .editMapProvider(let request):
            return try? request.asDictionary()
        case .updateAlarmEnabled(_ , let request):
            return try? request.asDictionary()
        case .parseSTT(let request):
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
        let encoder = JSONEncoder()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        formatter.locale = Locale(identifier: "ko_KR")
        
        encoder.dateEncodingStrategy = .formatted(formatter)
        
        let data = try encoder.encode(self)
        let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
        guard let result = dictionary as? [String: Any] else {
            throw RequestError.decode
        }
        return result
    }
}
