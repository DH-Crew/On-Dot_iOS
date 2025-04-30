//
//  MapProvider.swift
//  On-Dot
//
//  Created by 현수 노트북 on 4/30/25.
//

struct MapProvider: Codable {
    let mapProvider: MapType
    
    enum MapType: String, Codable {
        case kakao = "KAKAO"
        case naver = "NAVER"
        
        var title: String {
            switch self {
            case .kakao: return "카카오맵"
            case .naver: return "네이버맵"
            }
        }
        
        var image: String {
            switch self {
            case .kakao: return "ic_kakao_map"
            case .naver: return "ic_naver_map"
            }
        }
    }
    
    static let placeholder = MapProvider(
        mapProvider: .naver
    )
}
