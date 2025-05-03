//
//  CalculateRequest.swift
//  On-Dot
//
//  Created by 현수 노트북 on 4/28/25.
//

import Foundation

struct CalculateRequest: Codable {
    let appointmentAt: Date
    let startLongitude: Double
    let startLatitude: Double
    let endLongitude: Double
    let endLatitude: Double
}
