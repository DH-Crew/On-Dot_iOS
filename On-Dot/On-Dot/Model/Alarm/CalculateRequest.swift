//
//  CalculateRequest.swift
//  On-Dot
//
//  Created by 현수 노트북 on 4/28/25.
//

import Foundation

struct CalculateRequest: Codable {
    let appointmentAt: String
    let startLongitude: Double
    let startLatitude: Double
    let endLongitude: Double
    let endLatitude: Double

    init(date: Date, startLongitude: Double, startLatitude: Double, endLongitude: Double, endLatitude: Double) {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        
        self.appointmentAt = formatter.string(from: date)
        self.startLongitude = startLongitude
        self.startLatitude = startLatitude
        self.endLongitude = endLongitude
        self.endLatitude = endLatitude
    }
}
