//
//  SchduleRepositoryImpl.swift
//  On-Dot
//
//  Created by 현수 노트북 on 4/15/25.
//

final class ScheduleRepositoryImpl: ScheduleRepository {
    private let networkManager: NetworkManager
    
    init(
        networkManager: NetworkManager = NetworkManager.shared
    ) {
        self.networkManager = networkManager
    }
    
    func createSchedule(schedule: ScheduleInfo) async throws {
        _ = try await networkManager.request(type: EmptyResponse.self, api: .createSchedule(schedule: schedule))
    }
}
