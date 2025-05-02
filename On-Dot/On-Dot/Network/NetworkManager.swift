//
//  NetworkManager.swift
//  On-Dot
//
//  Created by 현수 노트북 on 4/14/25.
//

import Alamofire
import Foundation

final class NetworkManager {
    static let shared = NetworkManager()
    private init() {}

    func request<T: Decodable>(type: T.Type, api: Router) async throws -> T {
        let request = try api.asURLRequest()
        logRequest(request)

        let dataTask = AF.request(request).serializingData()
        let response = await dataTask.response
        
        logResponse(response)

        switch response.result {
        case .success(let data):
            if data.isEmpty, T.self == EmptyResponse.self {
                return EmptyResponse() as! T
            }

            do {
                let decoder = JSONDecoder()
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
                formatter.locale = Locale(identifier: "ko_KR")
                decoder.dateDecodingStrategy = .formatted(formatter)

                return try decoder.decode(T.self, from: data)
            } catch {
                throw error
            }
        case .failure(let error):
            if let statusCode = response.response?.statusCode {
                if statusCode == 401 {
                    throw RequestError.unauthorized
                } else {
                    throw RequestError.unexpectedStatusCode(statusCode)
                }
            }
            throw error
        }
    }
    
    private func logRequest(_ request: URLRequest) {
        print("""
        🔹 [요청 URL] \(request.url?.absoluteString ?? "")
        🔹 [Method] \(request.httpMethod ?? "")
        🔹 [Headers] \(request.allHTTPHeaderFields ?? [:])
        🔹 [Body] \(prettyPrintedJSON(data: request.httpBody))
        """)
    }
    
    private func logResponse(_ response: DataResponse<Data, AFError>) {
        let statusCode = response.response?.statusCode ?? -1
        let bodyString = String(data: response.data ?? Data(), encoding: .utf8) ?? "Body 없음"

        print("""
        🔸 [응답 StatusCode] \(statusCode)
        🔸 [응답 Body]
        \(bodyString)
        """)
    }
    
    private func prettyPrintedJSON(data: Data?) -> String {
        guard let data = data,
              let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []),
              let prettyData = try? JSONSerialization.data(withJSONObject: jsonObject, options: [.prettyPrinted]),
              let jsonString = String(data: prettyData, encoding: .utf8) else {
            return "Body 없음"
        }
        return jsonString
    }
}
