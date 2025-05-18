//
//  ScheduleRepository.swift
//  On-Dot
//
//  Created by 현수 노트북 on 4/15/25.
//

protocol ScheduleRepository {
    func createSchedule(schedule: ScheduleInfo) async throws -> Void
    func getSchedules() async throws -> HomeScheduleResponse
    func deleteSchedule(id: Int) async throws -> Void
    func getScheduleDetail(id: Int) async throws -> ScheduleInfo
    func editSchedule(id: Int, schedule: ScheduleInfo) async throws -> Void
    func updateAlarmEnabled(id: Int, request: AlarmEnabled) async throws -> Void
    func parseSTT(request: STTRequest) async throws -> STTResponse
}
