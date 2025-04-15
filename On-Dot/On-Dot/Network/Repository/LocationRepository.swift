//
//  LocationRepository.swift
//  On-Dot
//
//  Created by 현수 노트북 on 4/15/25.
//

protocol LocationRepository {
    func searchLocation(query: String) async throws -> [LocationSearchResult]
}
