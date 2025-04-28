//
//  AlarmRepository.swift
//  On-Dot
//
//  Created by 현수 노트북 on 4/28/25.
//

protocol AlarmRepository {
    func calculateAlarm(request: CalculateRequest) async throws -> CalculatedAlarmResponse
}
