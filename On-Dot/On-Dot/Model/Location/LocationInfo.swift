//
//  LocationSearchResultModel.swift
//  On-Dot
//
//  Created by 현수 노트북 on 4/15/25.
//

struct LocationInfo: Codable, Identifiable {
    let title: String
    let roadAddress: String
    let latitude: Double
    let longitude: Double
    
    var id: String { title + roadAddress }
    static let placeholder = LocationInfo(
        title: "",
        roadAddress: "",
        latitude: 0.0,
        longitude: 0.0
    )
}
