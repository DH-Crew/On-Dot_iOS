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
    
    func getSchedules() async throws -> HomeScheduleResponse {
        return try await networkManager.request(type: HomeScheduleResponse.self, api: .getSchedules)
    }
    
    func deleteSchedule(id: Int) async throws {
        _ = try await networkManager.request(type: EmptyResponse.self, api: .deleteSchedule(scheduleId: id))
    }
    
    func getScheduleDetail(id: Int) async throws -> ScheduleInfo {
        return try await networkManager.request(type: ScheduleInfo.self, api: .getScheduleDetail(scheduleId: id))
    }
    
    func editSchedule(id: Int, schedule: ScheduleInfo) async throws {
        _ = try await networkManager.request(type: EmptyResponse.self, api: .editSchedule(scheduleId: id, schedule: schedule))
    }
    
    func updateAlarmEnabled(id: Int, request: AlarmEnabled) async throws {
        _ = try await networkManager.request(type: EmptyResponse.self, api: .updateAlarmEnabled(scheduleId: id, request: request))
    }
}
