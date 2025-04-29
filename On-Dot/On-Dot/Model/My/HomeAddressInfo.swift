//
//  HomeAddressInfo.swift
//  On-Dot
//
//  Created by 현수 노트북 on 4/30/25.
//

struct HomeAddressInfo: Codable {
    let roadAddress: String
    let longitude: Double
    let latitude: Double
    
    static var placeholder = HomeAddressInfo(
        roadAddress: "서울특별시 강남구 테헤란로 123",
        longitude: 127.0276,
        latitude: 37.4979
    )
}
