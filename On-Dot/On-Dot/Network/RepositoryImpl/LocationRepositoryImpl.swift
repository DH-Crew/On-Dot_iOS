//
//  LocationRepositoryImpl.swift
//  On-Dot
//
//  Created by 현수 노트북 on 4/15/25.
//

final class LocationRepositoryImpl: LocationRepository {
    private let networkManager: NetworkManager
    
    init(
        networkManager: NetworkManager = NetworkManager.shared
    ) {
        self.networkManager = networkManager
    }
    
    func searchLocation(query: String) async throws -> [LocationInfo] {
        return try await networkManager.request(type: [LocationInfo].self, api: .searchPlace(query: query))
    }
}
