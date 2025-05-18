//
//  STTResponse.swift
//  On-Dot
//
//  Created by 현수 노트북 on 5/18/25.
//

import Foundation

struct STTResponse: Codable {
    let arrivalPlaceTitle: String
    let appointmentAt: String
    
    enum CodingKeys: String, CodingKey {
        case arrivalPlaceTitle = "departurePlaceTitle"
        case appointmentAt
    }
}

extension STTResponse {
    var appointmentDate: Date? {
        do {
            return try DateFormatterUtil.parseSimpleDate(from: appointmentAt)
        } catch {
            print("appointmentDate 파싱 실패: \(error.localizedDescription)")
            return nil
        }
    }
}
