//
//  ScheduleRepository.swift
//  On-Dot
//
//  Created by 현수 노트북 on 4/15/25.
//

protocol ScheduleRepository {
    func createSchedule(schedule: ScheduleRequest) async throws -> Void
}
